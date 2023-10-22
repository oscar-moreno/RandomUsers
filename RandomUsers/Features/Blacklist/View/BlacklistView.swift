import SwiftUI

struct BlacklistView: View {
    @ObservedObject var viewModel: BlacklistVM
    
    init(viewModel: BlacklistVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.blackList.isEmpty {
                    Text("blacklist_empty_text")
                } else {
                    List {
                        ForEach(viewModel.blackList, id: \.email) { user in
                            UserItemListView(user: user)
                        }
                    }
                }
            }
            .navigationTitle("blacklist_title")
        }
        
    }
}

struct BlacklistView_Previews: PreviewProvider {
    static var previews: some View {
        BlacklistView(viewModel: BlacklistVM(parentViewModel: HomeVM(networkService: RandomUsersNetworkService(httpClient: URLSessionHTTPClient()))))
    }
}
