import Foundation

struct Person: Codable {
    var id: Int = 1
    var lastName: String? = ""
    var firstName: String? = ""
    var mobile: String = ""
    var email: String? = ""
    var contacts: [Contacts] = []
    var about: String? = nil
    var photoFileId: String?
    var locationRefKeyId: Int? = nil
    var userId: Int? = nil
    var pendingEmails: [String] = []
    
    struct Contacts: Codable {
        let id: Int
        let value: String
        let typeRefKeyId: Int
    }
}
