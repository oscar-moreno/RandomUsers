import SwiftUI

@main
struct RandomUsersApp: App {
    private let dependencyInjection = DependencyInjection()
    
    var body: some Scene {
        WindowGroup {
            dependencyInjection.buildHomeView()
        }
    }
}
