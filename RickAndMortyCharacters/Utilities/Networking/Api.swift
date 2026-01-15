import Foundation

typealias ApiResult<T: Decodable> = Result<T, ApiError>

final class Api: ApiProtocol {
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func execute<T: Decodable>(endpoint: ApiEndpointProtocol, decoder: JSONDecoder) async -> ApiResult<T> {
        do {
            let request = try makeRequest(for: endpoint)
            
            let data = try await execute(request)
            
            let decoded = try decodeData(data, type: T.self, decoder: decoder)
            
            return .success(decoded)
        } catch let error as ApiError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
}

private extension Api {
    func makeRequest(for endpoint: ApiEndpointProtocol) throws -> URLRequest {
        var urlComponent = URLComponents(string: endpoint.absoluteURLString)
        urlComponent?.queryItems = endpoint.parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        guard let url = urlComponent?.url else { throw ApiError.malformedRequest }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.addValue(endpoint.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = TimeInterval(endpoint.timeout)
        
        endpoint.customHeaders.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if endpoint.shouldAppendBody, let body = endpoint.body {
            request.httpBody = body
        }
        
        return request
    }
    
    func execute(_ request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw ApiError.noConnection }
            
            try evaluateStatus(httpResponse.statusCode)
            
            return data
        } catch let error {
            if (error as NSError).code == NSURLErrorCancelled {
                throw ApiError.cancelled
            }
            
            throw error
        }
    }
    
    func evaluateStatus(_ statusCode: Int) throws {
        switch statusCode {
        case 200..<300:
            return
        case 404:
            throw ApiError.notFound
        default:
            throw ApiError.serverError(code: statusCode)
        }
    }
    
    func decodeData<T: Decodable>(_ data: Data, type: T.Type, decoder: JSONDecoder) throws -> T {
        do {
            let decoded = try decoder.decode(type, from: data)
            return decoded
        } catch {
            throw ApiError.decode
        }
    }
}
