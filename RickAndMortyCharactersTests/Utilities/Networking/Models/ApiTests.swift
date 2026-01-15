import Foundation
@testable import RickAndMortyCharacters
import Testing

private struct DecodableStub: Decodable, Equatable {
    let value: String
}

private extension ApiTests {
    typealias DependencySUT = (sut: Api, urlSessionSpy: URLSessionSpy)
    
    func makeSUT() -> DependencySUT {
        let urlSessionSpy = URLSessionSpy()
        let sut = Api(urlSession: urlSessionSpy)
        return (sut, urlSessionSpy)
    }
}

struct ApiTests {
    @Test
    func execute_ShouldCreateCorrectRequest() async throws {
        // Given
        let args = makeSUT()
        let baseURLString = "www.kuma.com"
        let path = "/test"
        let method: HTTPMethod = .post
        let timeout: Float = 10
        let body = "{ \"value\": true }".data(using: .utf8)
        let parameters: [String: String] = ["name": "kuma"]
        let customHeaders: [String: String] = ["token": "gk"]
        let endpointMock = ApiEndpointMock(
            baseURL: URL(filePath: baseURLString),
            path: path,
            method: method,
            timeout: timeout,
            body: body,
            shouldAppendBody: true,
            parameters: parameters,
            customHeaders: customHeaders,
            contentType: .applicationJson
        )
        
        // When
        let _: ApiResult<NoContent> = await args.sut.execute(endpoint: endpointMock)
        
        // Then
        let (receivedRequest, _) = try #require(args.urlSessionSpy.dataInvocations.first)
        #expect(receivedRequest.url == URL(string: "file:///www.kuma.com/test?name=kuma"))
        #expect(receivedRequest.httpMethod == method.rawValue)
        #expect(receivedRequest.timeoutInterval == TimeInterval(timeout))
        customHeaders.forEach { key, value in
            #expect(receivedRequest.value(forHTTPHeaderField: key) == value)
        }
        #expect(receivedRequest.httpBody == body)
    }
    
    @Test
    func execute_WhenResponseIsNotHTTPURLResponse_ShouldReturnNoConnectionApiError() async throws {
        // Given
        let args = makeSUT()
        args.urlSessionSpy.dataResponse = (Data(), URLResponse())
        let endpointMock = ApiEndpointMock()

        // When
        let result: ApiResult<NoContent> = await args.sut.execute(endpoint: endpointMock)
        
        // Then
        guard case .failure(let apiError) = result else {
            Issue.record("Execute should fail")
            return
        }
        guard case .noConnection = apiError else {
            Issue.record("Api error should be .noConnection, got: \(apiError)")
            return
        }
    }
    
    @Test(arguments: [
        (404, ApiError.notFound),
        (500, ApiError.serverError(code: 500))
    ])
    func execute_WhenErrorStatus_ShouldEvaluateStatusCodeCorrectly(statusCode: Int, expectedApiError: ApiError) async throws {
        // Given
        let args = makeSUT()
        let response = try #require(HTTPURLResponse(url: URL(filePath: ""),
                                                   statusCode: statusCode,
                                                   httpVersion: "",
                                                   headerFields: [:]))
        args.urlSessionSpy.dataResponse = (Data(), response)
        let endpointMock = ApiEndpointMock()

        // When
        let result: ApiResult<NoContent> = await args.sut.execute(endpoint: endpointMock)
        
        // Then
        guard case .failure(let apiError) = result else {
            Issue.record("Execute should fail")
            return
        }
        #expect(apiError == expectedApiError)
    }
    
    @Test
    func execute_WhenResponseBodyDoesNotMatchDecodableModel_ShouldReturnDecodeError() async throws {
        // Given
        let args = makeSUT()
        args.urlSessionSpy.dataResponse = (Data(), HTTPURLResponse())
        let endpointMock = ApiEndpointMock()

        // When
        let result: ApiResult<DecodableStub> = await args.sut.execute(endpoint: endpointMock)
        
        // Then
        guard case .failure(let apiError) = result else {
            Issue.record("Execute should fail")
            return
        }
        #expect(apiError == .decode)
    }
    
    @Test
    func execute_WhenSuccess_ShouldReturnSuccessModel() async throws {
        // Given
        let args = makeSUT()
        let data = try #require("{ \"value\": \"Kuma\" }".data(using: .utf8))
        args.urlSessionSpy.dataResponse = (data, HTTPURLResponse())
        let endpointMock = ApiEndpointMock()

        // When
        let result: ApiResult<DecodableStub> = await args.sut.execute(endpoint: endpointMock)
        
        // Then
        guard case .success(let model) = result else {
            Issue.record("Execute should succeed")
            return
        }
        #expect(model.value == "Kuma")
    }
}

