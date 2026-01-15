import Foundation

typealias GetCharactersResult = Result<CharactersResponse, ApiError>

protocol CharactersListServicing {
    func getCharacters(searchParams params: CharactersListSearchParams) async -> GetCharactersResult
}

final class CharactersListService {
    private let api: ApiProtocol
    
    init(api: ApiProtocol) {
        self.api = api
    }
}

extension CharactersListService: CharactersListServicing {
    func getCharacters(searchParams params: CharactersListSearchParams) async -> GetCharactersResult {
        let endpoint = CharactersListEndpoint.getCharacters(params: params)
        return await api.execute(endpoint: endpoint)
    }
}
