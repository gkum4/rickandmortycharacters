@testable import RickAndMortyCharacters
import Foundation

struct ApiEndpointMock: ApiEndpointProtocol {
    var baseURL: URL = URL(filePath: "")
    
    var path: String = ""
    var method: HTTPMethod = .get
    var timeout: Float = 20
    var body: Data? = nil
    var shouldAppendBody: Bool = false
    var parameters: [String: String] = [:]
    var customHeaders: [String: String] = [:]
    var contentType: ContentType = .applicationJson
}
