import Foundation
import SwiftUI
import WebKit
import CryptoKit
import CommonCrypto

struct SignInNavigation {
    let login: VoidCallback
}

final class SignInViewController: BaseViewController {
    private let navigation: SignInNavigation
    private let store = SignInStore()
    var codeVerifier = ""
    var codeChallenge = ""
    let clientId = "AZoH1U87FFfUFlVaWAUjRBopeP0a"
    private var webView: WKWebView!
    
    init(navigation: SignInNavigation) {
        self.navigation = navigation
        super.init(nibName: nil, bundle: nil)
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
                case .recieve:
                    self.navigation.login()
                case .error(_):
                    print("ERROR!!!")
                }
            }
            .store(in: &bag)
    }
}

extension SignInViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other {
            if let _ = navigationAction.request.url {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.cancel)
            return
        }
        if let url = webView.url?.absoluteString, url.starts(with: "http://localhost:8080") {
            let words = url.components(separatedBy: "code=")
            if words.count > 1,
               let token = words[1].components(separatedBy: "&").first {
                webView.isHidden = true
                store.actions.send(.login(token, clientId, codeVerifier))
            }
        }
        decisionHandler(.allow)
    }

    override func setupViews() {
        super.setupViews()
        setupWebView()
        setupObservers()
    }
    
    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "setToken")
        webView = WKWebView(frame: .zero, configuration: config)
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        
        let redirectUri = "http://localhost:8080"
        let stateGuid = UUID().uuidString
        codeVerifier = getCodeVerifier()
        codeChallenge = getCodeChallenge(verifier: codeVerifier)
        let queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "state", value: stateGuid),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "scope", value: "openid"),
        ]
        guard var urlComponents = URLComponents(string: "https://zanpro-dev.alseco.kz/oauth2/authorize")
        else { return }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func getCodeChallenge(verifier: String) -> String {
        guard let data = verifier.data(using: .utf8) else { return "" }
        var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
        }
        let hash = Data(buffer)
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return challenge
    }

    private func getCodeVerifier() -> String{
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let verifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return verifier
    }
    
    private func showAlert(_ message: String) {
        let cancelAction = UIAlertAction(title: "Ок", style: .cancel)
        let alert = UIAlertController(title: nil, message: NSLocalizedString(message, comment: "Error description"), preferredStyle: .alert)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

extension SignInViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
    }
}
