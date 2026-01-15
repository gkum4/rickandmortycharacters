import SwiftUI

final class CharacterDetailsViewModel: ObservableObject {
    @Published var viewState: CharacterDetailsViewState = .loading
    
    private let id: Int
    private let service: CharacterDetailsServicing
    private let asyncTask: AsyncTasking
    
    init(id: Int,
         service: CharacterDetailsServicing = CharacterDetailsService(),
         asyncTask: AsyncTasking = AsyncTask()) {
        self.id = id
        self.service = service
        self.asyncTask = asyncTask
    }
}
 
extension CharacterDetailsViewModel {
    func fetchCharacter() {
        viewState = .loading
        
        asyncTask.execute { [weak self] in
            guard let self else { return }
            
            let result = await service.getCharacter(withId: id)
            await handleFetchResult(result)
        }
    }
}

private extension CharacterDetailsViewModel {
    func handleFetchResult(_ result: GetCharacterResult) async {
        await MainActor.run {
            switch result {
            case .success(let character):
                viewState = .content(character)
            case .failure:
                viewState = .error
            }
        }
    }
}
