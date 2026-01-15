@testable import RickAndMortyCharacters

extension CharactersResponse {
    static func fixture(info: CharactersResponse.Info = .fixture(),
                        results: [Character] = [.fixture(id: 1), .fixture(id: 2)]) -> Self {
        .init(info: info, results: results)
    }
}

extension CharactersResponse.Info {
    static func fixture(count: Int = 20,
                        pages: Int = 30,
                        next: String? = "https://rickandmortyapi.com/api/character/?page=20",
                        prev: String? = "https://rickandmortyapi.com/api/character/?page=18") -> Self {
        .init(count: count, pages: pages, next: next, prev: prev)
    }
}
