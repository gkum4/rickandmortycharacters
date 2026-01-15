import Foundation

struct Character: Decodable, Equatable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

extension Character {
    enum Status: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }
    
    enum Gender: String, Decodable {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown
    }
    
    struct Origin: Decodable, Equatable {
        let name: String
        let url: String
    }
    
    struct Location: Decodable, Equatable {
        let name: String
        let url: String
    }
}
