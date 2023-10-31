import UIKit

final class ProfileCoordinator: BaseCoordinator {
    var onFlowDidFinish: VoidCallback?
    
    override func start() {
        let controller = makeProfile()
        router.setRootModule(controller)
    }
}

extension ProfileCoordinator {
    private func makeProfile() -> BaseViewControllerProtocol {
        return ProfileViewController()
    }
}
