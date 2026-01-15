@testable import RickAndMortyCharacters
import Foundation

final class URLSessionSpy: URLSessionProtocol {
    private(set) var dataInvocations: [(request: URLRequest, delegate: URLSessionTaskDelegate?)] = []
    var dataError: Error? = nil
    var dataResponse: (Data, URLResponse) = (Data(), URLResponse())
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        dataInvocations.append((request, delegate))
        
        if let dataError {
            throw dataError
        }
        
        return dataResponse
    }
}
