import Foundation
@testable import RandomUsers

struct RandomUsersNetworkServiceMock: NetworkService {
    var fakeResults = [User]()
    var fakeUsers: Users
    var fakeInfo: Info

    init(fakeResults: [User], fakeInfo: Info) {
        self.fakeResults = fakeResults
        self.fakeInfo = fakeInfo
        fakeUsers = Users(results: fakeResults, info: fakeInfo)
    }

    func getUsers(with params: NetworkParams) async throws -> Users {
        fakeUsers
    }
}
