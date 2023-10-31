import UIKit

enum ZanDictionary: String {
    case locations
    case specializations
    case activity = "activity_areas"
    case offers
    case moderation = "moderation_statuses"
    case contact = "contact_types"
}
enum ProfileEvent {
    case avatar(UIImage)
    case recieve(Person)
    case recieveLegal([Legal])
    case recieveLocations([Reference])
    case recieveSpecializations([Reference])
    case recieveActivityAreas([Reference])
    case recieveOffers([Reference])
    case recieveModerationStatus([Reference])
    case recieveContactTypes([Reference])
    case logout(ProfileSteps)
    case success(String)
    case error(String)
}

enum ProfileAction {
    case saveAvatar(UIImage)
    case savePerson(Person)
    case saveLegals([Legal])
    case deleteAvatar
    case deleteLegal(Int)
    case fetch
    case fetchPerson
    case fetchAvatar(String)
    case updateRegMail(String)
    case mobileOTPSending(String)
}

final class ProfileStore: Store<ProfileEvent, ProfileAction> {
    override func handleActions(_ action: ProfileAction) {
        switch action {
        case .fetchPerson:
            statefulCall {
                try await self.fetchPerson()
                try await self.fetchLegal()
            }
        case .fetchAvatar(let image):
            statefulCall {
                try await self.fetchAvatar(image: image)
            }
        case .fetch:
            statefulCall {
                try await self.fetch()
            }
        case .deleteAvatar:
            statefulCall {
                try await self.deleteAvatar()
            }
        case .saveAvatar(let image):
            statefulCall {
                try await self.saveAvatar(image)
            }
        case .savePerson(let person):
            statefulCall {
                try await self.savePerson(person)
            }
        case .updateRegMail(let mail):
            statefulCall {
                try await self.updateReg(newEmail: mail)
            }
        case .mobileOTPSending(let mobile):
            statefulCall {
                try await self.mobileOTPSending(newMobile: mobile)
            }
        case .saveLegals(let legals):
            statefulCall {
                try await self.saveLegals(legals)
            }
        case .deleteLegal(let id):
            statefulCall {
                try await self.deleteLegal(id)
            }
        }
    }
    
    private func fetchPerson() async throws {
        let (data, code) = try await RESTClient.shared.GET(path: "/zanpro-api/api/v1/person")
        if code == 200 {
            if let person = try? JSONDecoder().decode(Person.self, from: data) {
                sendEvent(.recieve(person))
            } else {
                print("DEBUG: не удалось извлечь данные")
            }
        } else if code == 401 {
            sendEvent(.logout(.fetchPerson))
        } else {
            print("DEBUG: code = \(code ?? 0)", String(data: data, encoding: .utf8) ?? "no data")
        }
    }
    
    private func savePerson(_ person: Person) async throws {
        let (_, code) = try await RESTClient.shared.PUT(
            path: "/zanpro-api/api/v1/person",
            body: person,
            headers: ["Content-Type": "application/json"])
        if code == 200 {
            sendEvent(.success("Успешно сохранили профиль"))
        } else {
            sendEvent(.logout(.savePerson(person)))
        }
    }
    
    private func fetchAvatar(image: String) async throws {
        let (data, code) = try await RESTClient.shared.GET(path: "/zanpro-files/internal/v1/file/\(image)/download", headers: [
            :])
        if code == 200, let uiImage = UIImage(data: data) {
            sendEvent(.avatar(uiImage))
        } else if code == 401 {
            sendEvent(.logout(.fetchAvatar(image)))
        }
    }
    
    private func deleteAvatar() async throws {
        let (_, code) = try await RESTClient.shared.DELETE(
            path: "/zanpro-api/api/v1/person/photo")
        if code == 200 {
            sendEvent(.success("Успешно удалили фото"))
        } else if code == 401 {
            sendEvent(.logout(.deleteAvatar))
        } else {
            sendEvent(.error("Неизвестная ошибка"))
        }
    }
    
    private func saveAvatar(_ image: UIImage) async throws {
        let (_, code) = try await RESTClient.shared.POST(image: image)
        if code == 200 {
            sendEvent(.success("Успешно сохранили фото"))
        } else if code == 401 {
            sendEvent(.logout(.saveAvatar(image)))
        } else {
            sendEvent(.error("Неизвестная ошибка"))
        }

    }
    
    private func fetch() async throws {
        try await fetchLocations(.locations)
        try await fetchLocations(.specializations)
        try await fetchLocations(.offers)
        try await fetchLocations(.moderation)
        try await fetchLocations(.contact)
        try await fetchLocations(.activity)
    }
    
    private func fetchLocations(_ loc: ZanDictionary) async throws {
        let (data, code) = try await RESTClient.shared.GET(
            path: "/zanpro-refs/api/v1/refs/\(loc.rawValue)/ref-values?size=1000")
        
        if code == 200 {
            if let response = try? JSONDecoder().decode(LocationResponse.self, from: data) {
                switch loc {
                case .locations:
                    sendEvent(.recieveLocations(response.content))
                case .specializations: try await allPro(response.content)
                case .activity: try await allActivities(response.content)
                case .offers:
                    sendEvent(.recieveOffers(response.content))
                case .moderation:
                    sendEvent(.recieveModerationStatus(response.content))
                case .contact:
                    sendEvent(.recieveContactTypes(response.content))
                }
            } else {
                sendEvent(.error("Не удалось получить список \(loc.rawValue)"))
            }
        } else if code == 401 {
            sendEvent(.logout(.fetchLocations))
        }  else {
            sendEvent(.error("Неизвестная ошибка"))
        }
    }
    
    private func updateReg(newEmail: String) async throws {
        let (_, code) = try await RESTClient.shared.PUT(
            path: "/zanpro-api/api/v1/person/reg-info/email",
            body: UpdateEmailRequest(newEmail: newEmail,
                                     verifyEmail: false),
        headers: ["Content-Type" : "application/json"])
        if code == 200 {
            sendEvent(.success("Успешно поменяли почту"))
        } else if code == 401 {
            sendEvent(.logout(.updateRegMail(newEmail)))
        } else {
            sendEvent(.error("Не удалось сохранить"))
        }
    }
    
    private func mobileOTPSending(newMobile: String) async throws {
        let (data, code) = try await RESTClient.shared.PUT(
            path: "/zanpro-api/api/v1/person/reg-info/mobile/otp-sending",
            body: UpdateMobileResponse(newMobileNumber: newMobile),
            headers: ["Content-Type" : "application/json"])
        if code == 200 {
            print("Код отправлен")
        } else {
            print(String(data: data, encoding: .utf8) ?? "?")
        }
    }
    
    private func addEmail(id: Int, email: String) async throws {
        let params = "contactId=\(id)&newEmail=\(email)"
        let (_, _) = try await RESTClient.shared.PUT(path: "/zanpro-api/api/v1/person/contact-info/email?contactId=\(id)&newEmail=\(email)", params: params)
        
    }
    
    private func allActivities(_ items: [Reference]) async throws {
        var results = items
        for index in results.indices {
            let item = results[index]
            let (data, code, name) = try await fetchChilds(name: item.refKeyCodeName, source: "activity_areas", target: "offers")
            if code == 200,
                name == item.refKeyCodeName,
                let response = try? JSONDecoder().decode(ChildResponse.self, from: data) {
                results[index].childs = response.content
            }
        }
        sendEvent(.recieveActivityAreas(results))
    }

    private func allPro(_ items: [Reference]) async throws {
        var results = items
        for index in results.indices {
            let item = results[index]
            let (data, code, name) = try await fetchChilds(name: item.refKeyCodeName, source: "specializations", target: "activity_areas")
            if code == 200,
                name == item.refKeyCodeName,
                let response = try? JSONDecoder().decode(ChildResponse.self, from: data) {
                results[index].childs = response.content
            }
        }
        sendEvent(.recieveSpecializations(results))
    }
    
    private func fetchChilds(name: String, source: String, target: String) async throws -> (Data, Int?, String) {
        let (data, code) = try await RESTClient.shared.READ(
            path: "/zanpro-refs/api/v1/ref-to-ref/source-ref-id/\(source)/target-ref-id/\(target)/source-key-id/\(name)?size=1000")
        return (data, code, name)
    }
    
    
}
// MARK: - Legal
extension ProfileStore {
    private func saveLegals(_ legals: [Legal]) async throws {
        let (data, code) = try await RESTClient.shared.POST(path: "/zanpro-api/api/v1/person-legal/moderation", body: legals, headers: ["Content-Type": "application/json"])
        print("Save legal", String(data: data, encoding: .utf8) ?? "", code ?? 0)
    }
    private func fetchLegal() async throws {
        let (data, code) = try await RESTClient.shared.GET(path: "/zanpro-api/api/v1/person-legal/moderation")
        if code == 200 {
            if let result = try? JSONDecoder().decode([LegalResponse].self, from: data) {
                let legals = result.compactMap({$0.onVerification})
                print(legals)
                sendEvent(.recieveLegal(legals))
            } else {
                print("DEBUG: не удалось извлечь данные")
            }
        } else if code == 401 {
            sendEvent(.logout(.fetchPerson))
        } else {
            print("DEBUG: code = \(code ?? 0)", String(data: data, encoding: .utf8) ?? "no data")
        }
    }
    private func deleteLegal(_ id: Int) async throws {
        let (data, code) = try await RESTClient.shared.DELETE(path: "/zanpro-api/api/v1/person-legal/moderation/\(id)")
        print("Attention!!!", String(data: data, encoding: .utf8) ?? "no!!!!", code ?? 0)
    }
}

struct UpdateEmailRequest: Codable {
    let newEmail: String
    let verifyEmail: Bool
}

struct UpdateMobileResponse: Codable {
    let newMobileNumber: String
}

struct LegalReques: Encodable {
    var specializationRefKeyId = 1
    var  license = "0001"
    var careerStartDate = "2012-01-01"
    var activityAreasWithOffers = [Offers(activityAreaId: 6, offerRefKeyIds: [146, 81])]
}
