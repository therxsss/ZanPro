import Foundation

final class AuthCoordinator: BaseCoordinator {
    var onFlowDidFinish: VoidCallback?
    override func start() {
        let controller = makeSignUp()
        router.setRootModule(controller)
    }

    private func runSignIn() {
        let controller = makeSignIn()
        router.push(controller)
    }
    
    private func runSignUp() {
        let controller = makeSignUp()
        router.push(controller)
    }
}

extension AuthCoordinator {
    private func makeSignUp() -> BaseViewControllerProtocol {
        let navigation = SignUpNavigation(login: {
            self.runSignIn()
        })
        return SignUpViewController(navigation: navigation)
    }
    
    private func makeSignIn() -> BaseViewControllerProtocol {
        let navigation = SignInNavigation {
            self.onFlowDidFinish?()
        }
        return SignInViewController(navigation: navigation)
    }
}
