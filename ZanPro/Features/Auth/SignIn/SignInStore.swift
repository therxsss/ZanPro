import Foundation

enum SignInEvent {
    case recieve
    case error(String)
}

enum SignInAction {
    case login(String, String, String)
}

final class SignInStore: Store<SignInEvent, SignInAction> {
    override func handleActions(_ action: SignInAction) {
        switch action {
        case .login(let code, let clientId, let codeVerifier):
            statefulCall {
                try await self.login(code: code, clientId: clientId, codeVerifier: codeVerifier)
            }
        }
    }
    
    private func login(code: String, clientId: String, codeVerifier: String) async throws {
        let params = "grant_type=authorization_code&" +
            "code=\(code)&" +
            "redirect_uri=http://localhost:8080&" +
            "client_id=\(clientId)&" +
            "code_verifier=\(codeVerifier)"
        let (data, code) = try await RESTClient.shared.POST(
            path: "/oauth2/token",
            params: params,
            headers: ["Content-Type" : "application/x-www-form-urlencoded"])
        if code == 200 {
            if let token = try? JSONDecoder().decode(TokenResponse.self, from: data) {
                RESTClient.shared.accessToken = token.accessToken
                RESTClient.shared.refreshToken = token.refreshToken
                sendEvent(.recieve)
            }
        } else if let response = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            sendEvent(.error(response.message))
        }
    }
}
