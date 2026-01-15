import Foundation

enum CharactersListEndpoint {
    case getCharacters(params: CharactersListSearchParams)
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
        case let .getCharacters(params):
            return makeGetCharactersParametersDict(params: params)
        }
    }
}

private extension CharactersListEndpoint {
    func makeGetCharactersParametersDict(params: CharactersListSearchParams) -> [String: String] {
        var dict: [String: String] = ["page": String(params.page)]
        
        if let name = params.name {
            dict["name"] = name
        }
        
        if let status = params.status {
            dict["status"] = status.rawValue
        }
        
        return dict
    }
}
