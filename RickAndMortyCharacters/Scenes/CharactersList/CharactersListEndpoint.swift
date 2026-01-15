import Foundation

enum CharactersListEndpoint {
    case getCharacters(page: Int)
}

extension CharactersListEndpoint: ApiEndpointProtocol {
    var baseURL: URL { apiBaseURL }
    
    var path: String {
        switch self {
        case .getCharacters:
            return "/character"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getCharacters(let page):
            return ["page": String(page)]
        }
    }
}
