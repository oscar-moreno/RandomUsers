import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeVM
    
    init(viewModel: HomeVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.users, id: \.email) { user in
                    NavigationLink {
                        UserView(user: user)
                    } label: {
                        UserItemListView(user: user)
                    }
                    .task {
                        if viewModel.mustLoadMoreUsers(from: user) {
                            await viewModel.loadUsers()
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .padding()
            }
            .listStyle(.plain)
            .refreshable {
                Task {
                    await viewModel.loadUsers()
                }
            }
            .navigationTitle("home_view_title")
        }
        .alert(isPresented: $viewModel.showWarning, content: {
            let localizedString = NSLocalizedString("warning_title", comment: "").uppercased()
            return Alert(title: Text(localizedString), message: Text(viewModel.showWarningMessage))
        })
        .task {
            await viewModel.loadUsers()
        }
        .disableAutocorrection(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeVM(networkService: RandomUsersNetworkService(httpClient: URLSessionHTTPClient())))
    }
}
