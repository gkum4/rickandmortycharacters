@testable import RickAndMortyCharacters
import Testing

private extension CharacterDetailsServiceTests {
    typealias DependencySUT = (
        sut: CharacterDetailsService,
        apiSpy: ApiSpy
    )
    
    func makeSUT() -> DependencySUT {
        let apiSpy = ApiSpy()
        let sut = CharacterDetailsService(api: apiSpy)
        return (sut, apiSpy)
    }
}

struct CharacterDetailsServiceTests {
    @Test
    func getCharacter_ShouldUseIdInEndpointPathAndReturnApiResult() async throws {
        // Given
        let args = makeSUT()
        let response = Character.fixture()
        args.apiSpy.executeResult = .success(response)
        let id = 2
        
        // When
        let result = await args.sut.getCharacter(withId: id)
        
        // Then
        let executeInvocation = try #require(args.apiSpy.executeInvocations.first)
        #expect(executeInvocation.endpoint.path == "/character/\(id)")
        guard case .success(let resultResponse) = result else {
            Issue.record("Result must be success")
            return
        }
        #expect(resultResponse == response)
    }
}
