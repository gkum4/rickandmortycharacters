import SwiftUI

protocol CharactersListViewModeling: ObservableObject {
    var viewState: CharactersListViewState { get }
    var characters: [Character] { get }
    var isLoading: Bool { get }
    var searchText: String { get set }
    var filterStatus: Character.Status? { get set }
    
    func fetchCharacters()
    func fetchNextPageIfNeeded(itemIndex: Int)
}

final class CharactersListViewModel {
    @Published private(set) var viewState: CharactersListViewState = .content
    @Published private(set) var characters: [Character] = []
    @Published private(set) var isLoading: Bool = false
    var searchText: String = "" {
        didSet { observeSearchParamsChange() }
    }
    var filterStatus: Character.Status? = nil {
        didSet { observeSearchParamsChange() }
    }
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var totalCharactersCount: Int = 0
    private var currentNameFilter: String? = nil
    private var currentStatusFilter: Character.Status? = nil
    
    private let service: CharactersListServicing
    private let debouncer: Debouncing
    private let asyncTask: AsyncTasking
    
    init(service: CharactersListServicing = CharactersListService(),
         debouncer: Debouncing = Debouncer(),
         asyncTask: AsyncTasking = AsyncTask()) {
        self.service = service
        self.debouncer = debouncer
        self.asyncTask = asyncTask
    }
}

extension CharactersListViewModel: CharactersListViewModeling {
    func fetchCharacters() {
        let searchParams = makeSearchParams()
        
        isLoading = true
        viewState = .content
        asyncTask.execute { [weak self] in
            guard let self else { return }
            
            let result = await service.getCharacters(searchParams: searchParams)
            await handleFetchResult(result: result)
        }
    }
    
    func fetchNextPageIfNeeded(itemIndex: Int) {
        guard currentPage < totalPages, itemIndex == totalCharactersCount - 2 else { return }
        
        currentPage += 1
        fetchCharacters()
    }
}
 
private extension CharactersListViewModel {
    func handleFetchResult(result: GetCharactersResult) async {
        await MainActor.run { [weak self] in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                totalPages = response.info.pages
                characters += response.results
                totalCharactersCount += response.results.count
                viewState = characters.isEmpty ? .empty : .content
                
            case .failure(let error):
                switch error {
                case .notFound:
                    viewState = .empty
                default:
                    viewState = .error
                }
            }
            
            isLoading = false
        }
    }
    
    func makeSearchParams() -> CharactersListSearchParams {
        .init(page: currentPage, name: currentNameFilter, status: currentStatusFilter)
    }
    
    func observeSearchParamsChange() {
        debouncer.debounce { [weak self] in
            guard let self else { return }
            
            characters = []
            currentPage = 1
            totalPages = 1
            totalCharactersCount = 0
            currentNameFilter = searchText.isEmpty ? nil : searchText
            currentStatusFilter = filterStatus
            fetchCharacters()
        }
    }
}
