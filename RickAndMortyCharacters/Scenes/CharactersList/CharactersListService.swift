import Foundation

typealias GetCharactersResult = Result<CharactersResponse, ApiError>

protocol CharactersListServicing {
    func getCharacters(page: Int) async -> GetCharactersResult
}

final class CharactersListService {
    private let api: ApiProtocol
    
    init(api: ApiProtocol) {
        self.api = api
    }
}

extension CharactersListService: CharactersListServicing {
    func getCharacters(page: Int) async -> GetCharactersResult {
        let endpoint = CharactersListEndpoint.getCharacters(page: page)
        return await api.execute(endpoint: endpoint)
    }
}
