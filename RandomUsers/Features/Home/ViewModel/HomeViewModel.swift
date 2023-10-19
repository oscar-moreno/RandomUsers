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
        let params = NetworkParams(results: String(5))
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
}
