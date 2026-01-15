@testable import RickAndMortyCharacters
import Testing

private final class CharacterDetailsServiceSpy: CharacterDetailsServicing {
    private(set) var getCharacterInvocations: [Int] = []
    var getCharacterResult: GetCharacterResult = .failure(.cancelled)
    func getCharacter(withId id: Int) async -> RickAndMortyCharacters.GetCharacterResult {
        getCharacterInvocations.append(id)
        return getCharacterResult
    }
}

private extension CharacterDetailsViewModelTests {
    typealias DependencySUT = (
        sut: CharacterDetailsViewModel,
        serviceSpy: CharacterDetailsServiceSpy,
        asyncTaskMock: AsyncTaskMock
    )
    
    func makeSUT(id: Int = 1) -> DependencySUT {
        let serviceSpy = CharacterDetailsServiceSpy()
        let asyncTaskMock = AsyncTaskMock()
        let sut = CharacterDetailsViewModel(id: id, service: serviceSpy, asyncTask: asyncTaskMock)
        return (sut, serviceSpy, asyncTaskMock)
    }
}

struct CharacterDetailsViewModelTests {
    @Test
    func fetchCharacter_WhenLoading_ShouldChangeStateToLoading() async {
        // Given
        let args = makeSUT()
        let character = Character.fixture()
        args.serviceSpy.getCharacterResult = .success(character)
        
        // When
        args.sut.fetchCharacter()
        
        // Then
        #expect(args.sut.viewState == .loading)
    }
    
    @Test
    func fetchCharacter_WhenSuccess_ShouldChangeStateToSuccess() async {
        // Given
        let args = makeSUT()
        let character = Character.fixture()
        args.serviceSpy.getCharacterResult = .success(character)
        
        // When
        args.sut.fetchCharacter()
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.sut.viewState == .content(character))
    }
    
    @Test
    func fetchCharacter_WhenFailure_ShouldChangeStateToError() async {
        // Given
        let args = makeSUT()
        let character = Character.fixture()
        args.serviceSpy.getCharacterResult = .failure(.decode)
        
        // When
        args.sut.fetchCharacter()
        await args.asyncTaskMock.executeAllTasks()
        
        // Then
        #expect(args.sut.viewState == .error)
    }
}
