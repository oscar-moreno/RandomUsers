import Foundation
import SwiftUI

protocol HomeViewModel {
    func loadUsers() async
}

class HomeVM: ObservableObject, HomeViewModel {
    @Published var users = [User]()
    @Published var showWarning = false
    
    let networkService: NetworkService
    var showWarningMessage = String()
    private var error: RequestError?
    
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadUsers() async {
        let params = NetworkParams(results: String(10))
        await fetchUsers(with: params)
    }
    
    func fetchUsers(with params: NetworkParams) async {
        do {
            let result = try await networkService.getUsers(with: params)
            DispatchQueue.main.async {
                self.users += result.results
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error as? RequestError
                if self.error != .notFound {
                    self.showWarningMessage =
                    RandomUsersNetworkData.NetworErrorMessages.dataNotAvailable.localizedString()
                    self.showWarning = true
                }
            }
        }
    }
    
    func mustLoadMoreUsers(from user: User) -> Bool {
        guard let index = users.firstIndex(where: { $0.email == user.email }) else { return false }

        return index + 4 == users.count
    }
    
    func delete(at offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }
}
