@testable import RickAndMortyCharacters
import Testing

private final class CharactersListServiceSpy: CharactersListServicing {
    private(set) var getCharactersInvocations: [CharactersListSearchParams] = []
    var getCharactersResult: GetCharactersResult = .failure(.cancelled)
    func getCharacters(searchParams params: CharactersListSearchParams) async -> GetCharactersResult {
        getCharactersInvocations.append(params)
        return getCharactersResult
    }
}

private extension CharactersListViewModelTests {
    typealias DependencySUT = (
        sut: CharactersListViewModel,
        serviceSpy: CharactersListServiceSpy,
        debouncerMock: DebouncerMock,
        asyncTaskMock: AsyncTaskMock
    )
    
    func makeSUT() -> DependencySUT {
        let serviceSpy = CharactersListServiceSpy()
        let debouncerMock = DebouncerMock()
        let asyncTaskMock = AsyncTaskMock()
        let sut = CharactersListViewModel(service: serviceSpy, debouncer: debouncerMock, asyncTask: asyncTaskMock)
        return (sut, serviceSpy, debouncerMock, asyncTaskMock)
    }
}

struct CharactersListViewModelTests {
    @Test
    func fetchCharacters_WhenErrorIsNotFound_ShouldSetStateToEmpty() async {
        // Given
        let args = makeSUT()
        args.serviceSpy.getCharactersResult = .failure(.notFound)
        
        // When
        args.sut.fetchCharacters()
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.sut.viewState == .empty)
    }
    
    @Test
    func fetchCharacters_WhenResultsIsEmpty_ShouldSetStateToEmpty() async {
        // Given
        let args = makeSUT()
        args.serviceSpy.getCharactersResult = .success(.fixture(results: []))
        
        // When
        args.sut.fetchCharacters()
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.sut.viewState == .empty)
    }
    
    @Test
    func fetchCharacters_WhenError_ShouldSetStateToError() async {
        // Given
        let args = makeSUT()
        args.serviceSpy.getCharactersResult = .failure(.malformedRequest)
        
        // When
        args.sut.fetchCharacters()
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.sut.viewState == .error)
    }
    
    @Test
    func fetchCharacters_WhenSuccess_ShouldSetCharacters() async {
        // Given
        let args = makeSUT()
        let response = CharactersResponse.fixture()
        args.serviceSpy.getCharactersResult = .success(response)
        
        // When
        args.sut.fetchCharacters()
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.sut.characters == response.results)
    }
    
    @Test
    func fetchNextPageIfNeeded_WhenOnSubLastIndex_ShouldFetchCharacters() async {
        // Given
        let args = makeSUT()
        let response = CharactersResponse.fixture(
            info: .fixture(pages: 10),
            results: [
                .fixture(id: 0),
                .fixture(id: 1),
                .fixture(id: 2),
                .fixture(id: 3),
            ]
        )
        args.serviceSpy.getCharactersResult = .success(response)
        args.sut.fetchCharacters()
        await args.asyncTaskMock.executeAllTasks()
        
        // When
        args.sut.fetchNextPageIfNeeded(itemIndex: 2)
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.serviceSpy.getCharactersInvocations.count == 2)
    }
    
    @Test
    func fetchNextPageIfNeeded_WhenNotSubLastIndex_ShouldNotFetchCharacters() async {
        // Given
        let args = makeSUT()
        let response = CharactersResponse.fixture(
            info: .fixture(pages: 10),
            results: [
                .fixture(id: 0),
                .fixture(id: 1),
                .fixture(id: 2),
                .fixture(id: 3),
            ]
        )
        args.serviceSpy.getCharactersResult = .success(response)
        args.sut.fetchCharacters()
        await args.asyncTaskMock.executeAllTasks()
        
        // When
        args.sut.fetchNextPageIfNeeded(itemIndex: 1)
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.serviceSpy.getCharactersInvocations.count == 1)
    }
    
    @Test
    func fetchNextPageIfNeeded_WhenOnLastPage_ShouldNotFetchCharacters() async {
        // Given
        let args = makeSUT()
        let response = CharactersResponse.fixture(
            info: .fixture(pages: 1),
            results: [
                .fixture(id: 0),
                .fixture(id: 1),
                .fixture(id: 2),
                .fixture(id: 3),
            ]
        )
        args.serviceSpy.getCharactersResult = .success(response)
        args.sut.fetchCharacters()
        await args.asyncTaskMock.executeAllTasks()
        
        // When
        args.sut.fetchNextPageIfNeeded(itemIndex: 2)
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.serviceSpy.getCharactersInvocations.count == 1)
    }
    
    @Test
    func setSearchText_ShouldTriggerDebounce() {
        // Given
        let args = makeSUT()
        
        // When
        args.sut.searchText = "test"
        
        // Then
        #expect(args.debouncerMock.debounceInvocations.count == 1)
    }
    
    @Test
    func setSearchText_AfterDebounce_ShouldFetchCharacters() async throws {
        // Given
        let args = makeSUT()
        let searchText = "Test"
        
        // When
        args.sut.searchText = searchText
        args.debouncerMock.executeLast()
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        let getCharacterInvocation = try #require(args.serviceSpy.getCharactersInvocations.first)
        #expect(getCharacterInvocation.name == searchText)
    }
    
    
    @Test
    func setFilterStatus_ShouldTriggerDebounce() {
        // Given
        let args = makeSUT()
        
        // When
        args.sut.filterStatus = .dead
        
        // Then
        #expect(args.debouncerMock.debounceInvocations.count == 1)
    }
    
    @Test
    func setFilterStatus_AfterDebounce_ShouldFetchCharacters() async throws {
        // Given
        let args = makeSUT()
        let status = Character.Status.dead
        
        // When
        args.sut.filterStatus = status
        args.debouncerMock.executeLast()
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        let getCharacterInvocation = try #require(args.serviceSpy.getCharactersInvocations.first)
        #expect(getCharacterInvocation.status == status)
    }
}
