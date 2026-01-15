@testable import RickAndMortyCharacters
import Testing

private extension CharactersListServiceTests {
    typealias DependencySUT = (
        sut: CharactersListService,
        apiSpy: ApiSpy
    )
    
    func makeSUT() -> DependencySUT {
        let apiSpy = ApiSpy()
        let sut = CharactersListService(api: apiSpy)
        return (sut, apiSpy)
    }
}

struct CharactersListServiceTests {
    @Test
    func getCharacters_ShouldUsePageInEndpointParametersAndReturnApiResult() async throws {
        let args = makeSUT()
        let response = CharactersResponse.fixture()
        args.apiSpy.executeResult = .success(response)
        let page = 3
        
        let result = await args.sut.getCharacters(page: page)
        
        let executeInvocation = try #require(args.apiSpy.executeInvocations.first)
        #expect(executeInvocation.endpoint.parameters["page"] == String(page))
        guard case .success(let resultResponse) = result else {
            Issue.record("Result must be success")
            return
        }
        #expect(resultResponse == response)
    }
}
