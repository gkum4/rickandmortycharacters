import Foundation

typealias GetCharacterResult = Result<Character, ApiError>

protocol CharacterDetailsServicing {
    func getCharacter(withId id: Int) async -> GetCharacterResult
}

final class CharacterDetailsService {
    private let api: ApiProtocol
    
    init(api: ApiProtocol = Api()) {
        self.api = api
    }
}

extension CharacterDetailsService: CharacterDetailsServicing {
    func getCharacter(withId id: Int) async -> GetCharacterResult {
        let endpoint = CharacterDetailsEndpoint.details(id: id)
        return await api.execute(endpoint: endpoint)
    }
}
