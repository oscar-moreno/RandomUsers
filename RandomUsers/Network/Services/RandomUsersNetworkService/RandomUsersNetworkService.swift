import Foundation

protocol NetworkService {
    func getUsers(with params: NetworkParams) async throws -> Users
}

struct NetworkParams {
    let results: String?
}

struct RandomUsersNetworkService: NetworkService {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getUsers(with params: NetworkParams) async throws -> Users {
        var usersUrlComponents = buildUrlComponentsBase(endpoint: RandomUsersEndpoints.users)
        usersUrlComponents.queryItems = [URLQueryItem]()
        
        var query = [String: String]()
        query[RandomUsersNetworkData.resultsParam] = params.results
        
        query.forEach { key, value in
            let queryItem = URLQueryItem(name: key, value: value)
            usersUrlComponents.queryItems?.append(queryItem)
        }
        
        guard let url = usersUrlComponents.url else {
            throw RequestError.invalidURL
        }
        
        return try await httpClient.sendRequest(url: url)
    }
    
    private func buildUrlComponentsBase(endpoint: Endpoint) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.transferProtocol
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        return urlComponents
    }
}
