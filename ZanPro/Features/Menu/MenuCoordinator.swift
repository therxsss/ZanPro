import Foundation

final class MenuCoordinator: BaseCoordinator {
    var onFlowDidFinish: VoidCallback?
    override func start() {
        let controller = makeMenu()
        router.setRootModule(controller)
    }
}

extension MenuCoordinator {
    private func makeMenu() -> BaseViewControllerProtocol {
        return MenuViewController()
    }
}

