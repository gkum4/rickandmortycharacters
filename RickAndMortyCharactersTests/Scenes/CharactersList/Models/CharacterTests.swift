import Foundation
@testable import RickAndMortyCharacters
import Testing

struct CharacterTests {
    @Test
    func decode_ShouldCorrespondToCorrectModel() throws {
        let data = try #require("""
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/1"
            },
            "location": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/20"
            },
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """.data(using: .utf8))
        
        let decodedModel = try JSONDecoder().decode(Character.self, from: data)
        
        #expect(decodedModel == .init(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: .init(
                name: "Earth",
                url: "https://rickandmortyapi.com/api/location/1"
            ),
            location: .init(
                name: "Earth",
                url: "https://rickandmortyapi.com/api/location/20"
            ),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ],
            url: "https://rickandmortyapi.com/api/character/1",
            created: "2017-11-04T18:48:46.250Z"
        ))
    }
}
