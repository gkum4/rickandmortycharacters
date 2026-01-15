import Foundation

struct CharactersResponse: Decodable, Equatable {
    let info: Info
    let results: [Character]
}

extension CharactersResponse {
    struct Info: Decodable, Equatable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
