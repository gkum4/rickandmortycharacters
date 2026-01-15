import Foundation

enum CharacterDetailsEndpoint {
    case details(id: Int)
}

extension CharacterDetailsEndpoint: ApiEndpointProtocol {
    var baseURL: URL { apiBaseURL }
    
    var path: String {
        switch self {
        case .details(let id):
            "/character/\(id)"
        }
    }
}
