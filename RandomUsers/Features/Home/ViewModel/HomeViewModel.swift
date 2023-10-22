import Foundation
import SwiftUI

protocol HomeViewModel {
    var usersBlacklist: [User] { get set }
    func loadUsers() async
}

final class HomeVM: ObservableObject, HomeViewModel {
    @Published var users = [User]()
    @Published var showWarning = false
    @Published var usersSearchText = ""
    
    var removedUsers = [User]()
    var usersBlacklist = [User]()
    let networkService: NetworkService
    var showWarningMessage = ""
    var currentPage = 0
    private var error: RequestError?
    private var blacklistIcon = "xmark.bin"
    private var notBlacklistIcon = "arrow.up.bin"
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadUsers() async {
        currentPage += 1
        let seed = "foobar"
        let params = NetworkParams(results: String(10), seed: seed, page: String(currentPage))
        await fetchUsers(with: params)
    }
    
    func loadUsersDebounced() {
        let debouncer = Debouncer(delay: 1.0) {
            Task {
                await self.loadUsers()
            }
        }
        debouncer.call()
    }
    
    func fetchUsers(with params: NetworkParams) async {
        do {
            let result = try await networkService.getUsers(with: params)
            DispatchQueue.main.async {
                if self.usersSearchText.isEmpty {
                    self.users.append(contentsOf: result.results.filter { user in
                        !self.users.contains(where: { $0.email == user.email })
                    })
                } else {
                    self.users.append(contentsOf: result.results.filter { user in
                        user.name.first.contains(self.usersSearchText) ||
                        user.name.last.contains(self.usersSearchText) ||
                        user.email.contains(self.usersSearchText) &&
                        !self.users.contains(where: { $0.email == user.email })
                    })
                }
                self.users.removeAll(where: { user in
                    self.removedUsers.contains(where: { $0.email == user.email })
                })
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
    
    func delete(_ user: User) {
        removedUsers.append(user)
        users.removeAll(where: { $0.email == user.email })
    }
    
    func resetUsers() {
        currentPage = 0
        DispatchQueue.main.async {
            self.users = [User]()
        }
    }
    
    func toogleBlackListed(_ user: User) {
        guard let index = users.firstIndex(where: { $0.email == user.email }) else { return }
        users[index].isBlackListed = !(user.isBlackListed ?? false)
        if users[index].isBlackListed ?? false {
            if !usersBlacklist.contains(where: { $0.email == user.email }) {
                usersBlacklist.append(user)
            }
        } else {
            usersBlacklist.removeAll(where: { $0.email == user.email })
        }
    }
    
    func getBlacklistIcon(_ user: User) -> String {
        !(user.isBlackListed ?? false) ? blacklistIcon : notBlacklistIcon
    }
}
