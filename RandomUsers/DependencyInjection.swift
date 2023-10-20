import Foundation

final class DependencyInjection {
    private let networkService: NetworkService
    private let homeViewModel: HomeVM
    private let httpClient: HTTPClient

    init() {
        httpClient = URLSessionHTTPClient()
        networkService = RandomUsersNetworkService(httpClient: httpClient)
        homeViewModel = HomeVM(networkService: networkService)
    }

    func buildHomeView() -> HomeView {
        HomeView(viewModel: homeViewModel)
    }
}
