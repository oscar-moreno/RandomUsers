import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(url: URL) async throws -> T
}

struct URLSessionHTTPClient: HTTPClient {
    func sendRequest<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.noResponse
        }
        
        switch response.statusCode {
        case 200...299:
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                throw RequestError.decode
            }
            return decodedResponse
        case 401:
            throw RequestError.unauthorized
        case 404:
            throw RequestError.notFound
        default:
            throw RequestError.unexpectedStatusCode
        }
    }
}
