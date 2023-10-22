import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeVM
    
    let buildBlacklistView: () -> BlacklistView
    
    init(viewModel: HomeVM, buildBlacklistView: @escaping () -> BlacklistView) {
        self.viewModel = viewModel
        self.buildBlacklistView = buildBlacklistView
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.users, id: \.email) { user in
                    ZStack {
                        UserItemListView(user: user)
                        NavigationLink(destination: UserView(user: user)) {
                        }
                        .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.delete(user)
                        } label: {
                            Label("delete_swipe_action", systemImage: "trash")
                        }
                        Button {
                            viewModel.setBlackListed(user)
                        } label: {
                            let blackListIcon = viewModel.getBlacklistIcon(user)
                            Label("blacklist_swipe_action", systemImage: blackListIcon)
                        }
                    }
                    .task {
                        if viewModel.mustLoadMoreUsers(from: user) {
                            await viewModel.loadUsers()
                        }
                    }
                    .listRowSeparator(.hidden)
                    .padding(.init(top: 1, leading: 0, bottom: 1, trailing: 0))
                }
            }
            .listStyle(.plain)
            .refreshable {
                Task {
                    await viewModel.loadUsers()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.displayBlackList.toggle()
                    } label: {
                        Text("blacklist_title")
                    }
                    .sheet(isPresented: $viewModel.displayBlackList) {
                        buildBlacklistView()
                    }

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
        .searchable(text: $viewModel.usersSearchText, prompt: "search_prompt")
        .autocorrectionDisabled()
        .autocapitalization(.none)
        .onChange(of: viewModel.usersSearchText, { _, newValue in
            viewModel.resetUsers()
            viewModel.usersSearchText = newValue
            viewModel.loadUsersDebounced()
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: 
                    HomeVM(networkService:
                            RandomUsersNetworkService(httpClient:
                                                        URLSessionHTTPClient()))) {
            BlacklistView(viewModel: BlacklistVM(parentViewModel:
                                                    HomeVM(networkService:
                                                            RandomUsersNetworkService(httpClient:
                                                                                        URLSessionHTTPClient()))))
        }
    }
}
