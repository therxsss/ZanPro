import Foundation

final class SearchCoordinator: BaseCoordinator {
    var onFlowDidFinish: VoidCallback?
    override func start() {
        let controller = makeProfile()
        router.setRootModule(controller)
    }
}

extension SearchCoordinator {
    private func makeProfile() -> BaseViewControllerProtocol {
        return ProfileViewController()
    }
}

