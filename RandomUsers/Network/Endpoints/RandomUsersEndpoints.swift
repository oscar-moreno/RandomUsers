import Foundation

enum RandomUsersEndpoints {
    case users
}

extension RandomUsersEndpoints: Endpoint {

    var header: [String: String]? {
        switch self {
        case .users:
            return RandomUsersNetworkData.header
        }
    }

    var path: String {
        switch self {
        case .users:
            return RandomUsersNetworkData.usersEndpoint
        }
    }

    var method: RequestMethod {
        switch self {
        case .users:
            return .get
        }
    }

    var body: [String: String]? {
        switch self {
        case .users:
            return nil
        }
    }

}
