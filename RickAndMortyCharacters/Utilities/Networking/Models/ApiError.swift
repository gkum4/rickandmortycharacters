enum ApiError: Error, Equatable {
    case noConnection
    case malformedRequest
    case unknown
    case cancelled
    case notFound
    case serverError(code: Int)
    case decode
}
