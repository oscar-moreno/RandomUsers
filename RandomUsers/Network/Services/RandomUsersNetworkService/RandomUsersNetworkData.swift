import Foundation

struct RandomUsersNetworkData {
    static let https = "https"
    static let apiHost = "randomuser.me"
    static var usersEndpoint = "/api/1.4/"
    static let header = ["Content-Type": "application/json;charset=utf-8"]
    static let resultsParam = "results"
    static let seedParam = "seed"
    static let pageParam = "page"

    enum NetworErrorMessages {
        case dataNotAvailable

        func localizedString() -> String {
            switch self {
            case .dataNotAvailable:
                return NSLocalizedString("data_not_available", comment: "")
            }
        }
    }
}
