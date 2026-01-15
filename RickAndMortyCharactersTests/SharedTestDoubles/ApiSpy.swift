import Foundation
@testable import RickAndMortyCharacters

final class ApiSpy: ApiProtocol {
    private(set) var executeInvocations: [(endpoint: ApiEndpointProtocol, decoder: JSONDecoder)] = []
    var executeResult: Result<Any, ApiError>?
    func execute<T: Decodable>(endpoint: ApiEndpointProtocol,
                               decoder: JSONDecoder) async -> Result<T, ApiError> {
        executeInvocations.append((endpoint, decoder))
        
        switch executeResult {
        case .success(let success):
            guard let successT = success as? T else { return .failure(.malformedRequest) }
            return .success(successT)
        case .failure(let failure):
            return .failure(failure)
        case .none:
            return .failure(.malformedRequest)
        }
    }
}
