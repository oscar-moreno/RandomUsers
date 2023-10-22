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
    @Published var displayBlackList = false
    
    var removedUsers = [User]()
    var usersBlacklist = [User]()
    let networkService: NetworkService
    var showWarningMessage = ""
    var currentPage = 0
    private var error: RequestError?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadUsers() async {
        currentPage += 1
        let seed = K.Network.seedFoobar
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
    
    fileprivate func fetchAllUsers(with result: Users) {
        self.users.append(contentsOf: result.results.filter { user in
            !self.users.contains(where: { $0.email == user.email })
        })
    }
    
    fileprivate func fetchSearchedUsers(with result: Users) {
        self.users.append(contentsOf: result.results.filter { user in
            user.name.first.contains(self.usersSearchText) ||
            user.name.last.contains(self.usersSearchText) ||
            user.email.contains(self.usersSearchText) &&
            !self.users.contains(where: { $0.email == user.email })
        })
    }
    
    fileprivate func removeDuplicatedUsersByEmail() {
        self.users.removeAll(where: { user in
            self.removedUsers.contains(where: { $0.email == user.email })
        })
    }
    
    fileprivate func resetIsBlackListedParam() {
        self.users = self.users.map { user in
            if self.usersBlacklist.contains(where: { $0.email == user.email }) {
                var user = user
                user.isBlackListed = true
                return user
            }
            return user
        }
    }
    
    fileprivate func handleFetchError(_ error: Error) {
        DispatchQueue.main.async {
            self.error = error as? RequestError
            if self.error != .notFound {
                self.showWarningMessage =
                RandomUsersNetworkData.NetworErrorMessages.dataNotAvailable.localizedString()
                self.showWarning = true
            }
        }
    }
    
    func fetchUsers(with params: NetworkParams) async {
        do {
            let result = try await networkService.getUsers(with: params)
            DispatchQueue.main.async {
                if self.usersSearchText.isEmpty {
                    self.fetchAllUsers(with: result)
                } else {
                    self.fetchSearchedUsers(with: result)
                }
                self.removeDuplicatedUsersByEmail()
                self.resetIsBlackListedParam()
            }
        } catch {
            handleFetchError(error)
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
    
    fileprivate func toggleIsBlackListedParam(with user: User) -> User {
        guard let index = users.firstIndex(where: { $0.email == user.email }) else { return user}
        users[index].isBlackListed = !(user.isBlackListed ?? false)
        return users[index]
    }
    
    fileprivate func addUserToBlacklist(_ user: User) {
        if !usersBlacklist.contains(where: { $0.email == user.email }) {
            usersBlacklist.append(user)
        }
    }
    
    fileprivate func removeUserFromBlacklist(_ user: User) {
        usersBlacklist.removeAll(where: { $0.email == user.email })
    }
    
    func setBlackListed(_ user: User) {
        let userToggled = toggleIsBlackListedParam(with: user)
        if userToggled.isBlackListed ?? false {
            addUserToBlacklist(user)
        } else {
            removeUserFromBlacklist(user)
        }
    }
    
    func getBlacklistIcon(_ user: User) -> String {
        !(user.isBlackListed ?? false) ? K.Icons.blacklistIcon : K.Icons.notBlacklistIcon
    }
}
