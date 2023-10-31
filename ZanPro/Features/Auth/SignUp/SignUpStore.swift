import Foundation

enum SignUpEvent {
    case sended
    case registered
    case error(String)
}

enum SignUpAction {
    case sendSMS(String)
    case register(String, String, String, String?)
}

final class SignUpStore: Store<SignUpEvent, SignUpAction> {
    override func handleActions(_ action: SignUpAction) {
        switch action {
        case .register(let phone, let password, let code, let email):
            statefulCall {
                try await self.register(phone: phone, password: password, code: code, email: email)
            }
        case .sendSMS(let phone):
            statefulCall {
                try await self.sendSMS(phone)
            }
        }
    }
    
    private func sendSMS(_ phone: String) async throws {
        let (data, code) = try await RESTClient.shared.POST(
            path: "/zanpro-api/api/v1/auth/verify-and-send-otp",
            body: SMSRequest(mobile: phone),
            headers: ["Content-Type":"application/json"])
        if code == 200 {
            sendEvent(.sended)
        } else if let response = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            sendEvent(.error(response.message))
        }
    }
        
    private func register(phone: String, password: String, code: String, email: String? = nil) async throws {
        let (data, code) = try await RESTClient.shared.POST(
            path: "/zanpro-api/api/v1/auth/sign-up",
            body: SignUpRequest(mobile: phone, password: password, otpCode: code, email: email),
            headers: ["Content-Type":"application/json"])
        if code == 201 {
            sendEvent(.registered)
        } else if let response = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            sendEvent(.error(response.message))
        }
    }
}

struct SignUpRequest: Codable {
    let mobile: String
    let password: String
    let otpCode: String
    let email: String?
}

struct CasesResponse: Codable {
    let totalElements: Int
}

struct SMSRequest: Codable {
    let mobile: String
}
