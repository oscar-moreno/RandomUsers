import Foundation

final class BlacklistVM: ObservableObject {
    @Published var blackList = [User]()
    
    private var parentViewModel: HomeViewModel
    
    init(parentViewModel: HomeViewModel) {
        self.parentViewModel = parentViewModel
        blackList = parentViewModel.usersBlacklist
    }
}
