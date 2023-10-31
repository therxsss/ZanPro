import SwiftUI

struct SignUpNavigation {
    let login: VoidCallback
}

final class SignUpViewController: BaseViewController {
    private let viewModel = SignUpViewModel()
    private let store = SignUpStore()
    private let navigation: SignUpNavigation
    private lazy var rootView: BridgedView = {
        SignUpView(viewModel: viewModel).bridge()
    }()
    
    init(navigation: SignUpNavigation) {
        self.navigation = navigation
        super.init(nibName: nil, bundle: nil)
        viewModel.sendSMS = { phone in
            self.store.actions.send(.sendSMS(phone))
        }
        viewModel.register = { phone, password, sms, email in
            self.store.actions.send(.register(phone, password, sms, email))
        }
        viewModel.close = { self.navigation.login() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .sended:
                    self.viewModel.showSMSField = true
                    print("DEBUG: получил ответ от сервера showSMSField = true")
                case .registered:
                    self.navigation.login()
                case .error(let error):
                    self.viewModel.showAlert = true
                    self.viewModel.alertMessage = error
                }
            }
            .store(in: &bag)
    }
}

extension SignUpViewController {
    override func setupViews() {
        super.setupViews()
        addBridgedViewAsRoot(rootView)
        setupObservers()
    }
}
