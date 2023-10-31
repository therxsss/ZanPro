// http://netshserver.asc.kz:3128
import UIKit

typealias Parameters = [String: Any]

enum RESTError: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    case unkown(Error)
    case message(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid url"
        case .serverError:
            return "There was an error with the server. Please try again later"
        case .invalidData:
            return "The data is invalid. Please try again later"
        case .unkown(let error):
            return error.localizedDescription
        case .message(let description):
            return description
        }
    }
}

final class RESTClient {
    var expiresIn = Date()
    let baseUrl = "https://zanpro-dev.alseco.kz/api"
    let loginUrl = "https://zanpro-dev.alseco.kz"
    static let shared = RESTClient()
    private init() {}
    
    func DELETE(path: String) async throws -> (Data, Int?) {
        guard let url = URL(string: baseUrl + path)
        else { throw RESTError.invalidURL }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        if !accessToken.isEmpty {
            try await refreshAccessToken()
            request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "DELETE"
        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode
        return (data, code)
    }
    
    func GET(path: String, headers: [String: String] = [:]) async throws -> (Data, Int?) {
        guard let url = URL(string: baseUrl + path)
        else { throw RESTError.invalidURL }
        var request = URLRequest(url: url)
        if !accessToken.isEmpty {
            try await refreshAccessToken()
            request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode
        return (data, code)
    }
    
    func READ(path: String) async throws -> (Data, Int?) {
        guard let url = URL(string: baseUrl + path)
        else { throw RESTError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode
        return (data, code)
    }
    
    func POST(path: String,
              params: String,
              headers: [String: String] = [:]) async throws -> (Data, Int?) {
        guard let url = URL(string: loginUrl + path)
        else { throw RESTError.invalidURL }
        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.timeoutInterval = 10
        request.httpBody = params.data(using: .utf8)
        request.httpMethod = "POST"
        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode
        return (data, code)
    }
    
    func PUT(path: String, params: String, headers: [String: String] = [:]) async throws -> (Data, Int?) {
        guard let url = URL(string: baseUrl + path)
        else { throw RESTError.invalidURL }
        var request = URLRequest(url: url)
        if !accessToken.isEmpty {
            try await refreshAccessToken()
            request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.timeoutInterval = 10
        if !params.isEmpty {
            request.httpBody = params.data(using: .utf8)
        }
        request.httpMethod = "PUT"
        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode
        return (data, code)
    }
    
    func refreshAccessToken() async throws {
        if needRefreshToken {
            if let message = try await refreshToken() {
                print("DEBUG: ", message)
            }
        }
    }
    
    func POST<Body: Encodable>(path: String,
                               body: Body,
                               headers: [String: String] = [:])
    async throws -> (Data, Int?) {
        guard let url = URL(string: baseUrl + path)
        else { throw RESTError.invalidURL }
        var request = URLRequest(url: url)
        if !accessToken.isEmpty {
            try await refreshAccessToken()
            request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode
        return (data, code)
    }
    
    func POST(image: UIImage) async throws -> (Data, Int?) {
        guard let url = URL(string: baseUrl + "/zanpro-api/api/v1/person/photo")
        else { throw RESTError.invalidURL }
        let boundary = "Boundary-\(UUID().uuidString)"
        let imageData = image.jpegData(compressionQuality: 0.7) ?? Data()
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        if !accessToken.isEmpty {
            try await refreshAccessToken()
            request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let body = NSMutableData()
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"avatar.jpg\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        request.httpBody = body as Data
        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode
        return (data, code)
    }
    
    func PUT<Body: Encodable>(path: String, body: Body,
                              headers: [String: String] = [:]) async throws -> (Data, Int?) {
        guard let url = URL(string: baseUrl + path)
        else { throw RESTError.invalidURL }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        if !accessToken.isEmpty {
            try await refreshAccessToken()
            request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(body)
        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode
        return (data, code)
    }
    
    func logout() {
        accessToken = ""
        refreshToken = ""
    }
    
    private func refreshToken() async throws -> String? {
        let params = "grant_type=refresh_token&" +
        "client_id=\(RESTClient.shared.clientId)&" +
        "refresh_token=\(RESTClient.shared.refreshToken)"
        let (data, code) = try await POST(
            path: "/oauth2/token",
            params: params,
            headers: ["Content-Type": "application/x-www-form-urlencoded"])
        if code == 200, let token = try? JSONDecoder().decode(TokenResponse.self, from: data) {
                RESTClient.shared.saveToken(token)
        } else if let response = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            return response.message
        }
        return nil
    }
    
    private enum Keys: String {
        case accessToken
        case refreshToken
        case clientId
    }
    
    var accessToken: String {
        get {
            UserDefaults.standard.string(forKey: Keys.accessToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.accessToken.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: Keys.refreshToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.refreshToken.rawValue)
        }
    }
    
    var clientId: String {
        get {
            UserDefaults.standard.string(forKey: Keys.clientId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.clientId.rawValue)
        }
    }
    
    func saveToken(_ token: TokenResponse) {
        accessToken = token.accessToken
        refreshToken = token.refreshToken
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .second, value: token.expiresIn, to: Date())
        expiresIn = date ?? Date()
    }
    
    var needRefreshToken: Bool {
        expiresIn < Date()
    }
}

extension RESTClient {
    func savePerson(body: Person) async throws {
        guard let url = URL(string: baseUrl + "/zanpro-api/api/v1/person")
        else { throw RESTError.invalidURL }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("Bearer " + accessToken,
                         forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        let (_, _) = try await URLSession.shared.data(for: request)
    }
        
    func firstGet<Response: Decodable>(path: String) async throws -> Response {
        guard let url = URL(string: baseUrl + path)
        else { throw RESTError.invalidURL }
        var request = URLRequest(url: url)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            throw RESTError.serverError
        }
        guard let response = try? JSONDecoder().decode(Response.self, from: data)
        else { throw RESTError.invalidData }
        return response
    }
}

struct ErrorResponse: Codable {
    let message: String
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

/*
 https://www.donnywals.com/uploading-images-and-forms-to-a-server-using-urlsession/
6470774fc057d272bc0b1c65
 */
