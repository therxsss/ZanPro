import UIKit

final class TabBarCoordinator: BaseCoordinator {
    var onFlowDidFinish: VoidCallback?
    private var bag = Bag()
    
    override func start() {
        runTab()
    }
    
    private func runTab() {
        let tabBar = makeTabBar()
        router.setRootModule(tabBar, hideNavBar: true)
        
        let modules = [makeMainModule(), makeSearchModule(), makeAppealModule(), makeMenuModule()]
        modules.forEach { coordinator, _ in
            addDependency(coordinator)
            coordinator.start()
        }
        let viewControllers = modules.map { $0.1 }
        tabBar.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        tabBar.setViewControllers(viewControllers, animated: false)
        viewControllers[3].title = "menu"
        tabBar.selectedIndex = 0
    }
}

extension TabBarCoordinator {
    private func makeTabBar() -> BaseViewControllerProtocol & UITabBarController {
        return TabBarController()
    }
    
    private func makeMainModule() -> (BaseCoordinator, UINavigationController) {
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(router: RouterImpl(rootController: navigationController))
        coordinator.onFlowDidFinish = onFlowDidFinish
        navigationController.tabBarItem = makeTabItem(for: .main)
        return (coordinator, navigationController)
    }
    
    private func makeSearchModule() -> (BaseCoordinator, UINavigationController) {
        let navigationController = UINavigationController()
        let coordinator = SearchCoordinator(router: RouterImpl(rootController: navigationController))
        coordinator.onFlowDidFinish = onFlowDidFinish
        navigationController.tabBarItem = makeTabItem(for: .search)
        return (coordinator, navigationController)
    }
    
    private func makeAppealModule() -> (BaseCoordinator, UINavigationController) {
        let navigationController = UINavigationController()
        let coordinator = AppealCoordinator(router: RouterImpl(rootController: navigationController))
        coordinator.onFlowDidFinish = onFlowDidFinish
        navigationController.tabBarItem = makeTabItem(for: .appeal)
        return (coordinator, navigationController)
    }
    
    private func makeMenuModule() -> (BaseCoordinator, UINavigationController) {
        let navigationController = UINavigationController()
        let coordinator = MenuCoordinator(router: RouterImpl(rootController: navigationController))
        coordinator.onFlowDidFinish = onFlowDidFinish
        navigationController.tabBarItem = makeTabItem(for: .menu)
        return (coordinator, navigationController)
    }

    private func makeTabItem(for type: TabItem) -> UITabBarItem {
        let item = UITabBarItem(
            title: type.title,
            image: UIImage(named: type.icon),
            selectedImage: UIImage(named: type.activeIcon)?.withRenderingMode(.alwaysOriginal)
        )
        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return item
    }
}

