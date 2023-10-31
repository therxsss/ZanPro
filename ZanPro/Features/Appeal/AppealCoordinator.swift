import Foundation

final class AppealCoordinator: BaseCoordinator {
    var onFlowDidFinish: VoidCallback?
    override func start() {
        let controller = makeProfile()
        router.setRootModule(controller)
    }
}

extension AppealCoordinator {
    private func makeProfile() -> BaseViewControllerProtocol {
        return ProfileViewController()
    }
}

