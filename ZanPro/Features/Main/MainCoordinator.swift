import Foundation

final class MainCoordinator: BaseCoordinator {
    var onFlowDidFinish: VoidCallback?
    override func start() {
        let controller = makeProfile()
        router.setRootModule(controller)
    }

}

extension MainCoordinator {
    private func makeProfile() -> BaseViewControllerProtocol {
        return ProfileViewController()
    }
}

