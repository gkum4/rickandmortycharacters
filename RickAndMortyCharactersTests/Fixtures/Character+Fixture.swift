@testable import RickAndMortyCharacters

extension Character {
    static func fixture(id: Int = 361,
                        name: String = "Toxic Rick",
                        status: Status = .dead,
                        species: String = "Humanoid",
                        type: String = "Rick's Toxic Side",
                        gender: Gender = .male,
                        origin: Origin = .fixture(),
                        location: Location = .fixture(),
                        image: String = "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
                        episode: [String] = ["https://rickandmortyapi.com/api/episode/27"],
                        url: String = "https://rickandmortyapi.com/api/character/361",
                        created: String = "2018-01-10T18:20:41.703Z") -> Self {
        .init(id: id,
              name: name,
              status: status,
              species: species,
              type: type,
              gender: gender,
              origin: origin,
              location: location,
              image: image,
              episode: episode,
              url: url,
              created: created)
    }
}

extension Character.Origin {
    static func fixture(name: String = "Alien Spa",
                        url: String = "https://rickandmortyapi.com/api/location/64") -> Self {
        .init(name: name, url: url)
    }
}

extension Character.Location {
    static func fixture(name: String = "Earth",
                        url: String = "https://rickandmortyapi.com/api/location/20") -> Self {
        .init(name: name, url: url)
    }
}
