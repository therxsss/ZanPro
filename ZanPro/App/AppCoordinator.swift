import Foundation

final class AppCoordinator: BaseCoordinator {
    override func start() {
//        startTabBarCoordinator()
        runAuth()
    }
    
    private func runAuth() {
        let coordinator = AuthCoordinator(router: router)
        coordinator.onFlowDidFinish = {
            self.startTabBarCoordinator()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func startTabBarCoordinator() {
        let coordinator = TabBarCoordinator(router: router)
        addDependency(coordinator)
        coordinator.onFlowDidFinish = {
            self.start()
        }
        coordinator.start()
    }
}
