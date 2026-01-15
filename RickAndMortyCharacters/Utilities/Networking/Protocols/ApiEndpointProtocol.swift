import Foundation

protocol ApiEndpointProtocol {
    // Obligatory
    var baseURL: URL { get }
    
    // Optional
    var path: String { get }
    var method: HTTPMethod { get }
    var timeout: Float { get }
    var body: Data? { get }
    var shouldAppendBody: Bool { get }
    var parameters: [String: String] { get }
    var customHeaders: [String: String] { get }
    var contentType: ContentType { get }
}

extension ApiEndpointProtocol {
    var path: String { "" }
    
    var method: HTTPMethod { .get }
    
    var body: Data? { nil }
    
    var shouldAppendBody: Bool { method != .get && method != .delete && body != nil }
    
    var timeout: Float { 20 }
    
    var parameters: [String: String] { [:] }
    
    var customHeaders: [String: String] { [:] }
    
    var contentType: ContentType { .applicationJson }
}

extension ApiEndpointProtocol {
    var absoluteURLString: String {
        let baseURLString = baseURL.absoluteString
        let safeBaseURLString = baseURLString.hasSuffix("/") ? String(baseURLString.dropLast()) : baseURLString
        let safePath = path.starts(with: "/") || path.isEmpty ? path : "/\(path)"
        return "\(safeBaseURLString)\(safePath)"
    }
}
