import Foundation

protocol HasApi {
    var api: ApiProtocol { get }
}

protocol ApiProtocol {
    func execute<T: Decodable>(endpoint: ApiEndpointProtocol,
                               decoder: JSONDecoder) async -> Result<T, ApiError>
}

extension ApiProtocol {
    func execute<T: Decodable>(endpoint: ApiEndpointProtocol) async -> Result<T, ApiError> {
        await execute(endpoint: endpoint, decoder: JSONDecoder())
    }
}
