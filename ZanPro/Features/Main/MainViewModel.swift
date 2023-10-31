import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var editMode = false
    var locations: [Reference] = []
    @Published var person: Person = Person(id: 1, lastName: "Петров", firstName: "Петров Петрович", mobile: "", email: "", contacts: [])
    var launchImagePicker: VoidCallback?
    var fullname: String {
        var result = ""
        if let lastname = person.lastName {
            result = lastname
        }
        if let firstname = person.firstName, !firstname.isEmpty {
            result = result.isEmpty ? firstname : result + " " + firstname
        }
        if result.isEmpty {
            result = "User-\(person.id)"
        }
        return result
    }
    @Published var test = ""
    @Published var uiImage: UIImage? = nil
    @Published var focusedField: ZPTextFieldType? = nil
    var titleField: String {
        editMode ? "Регистрация специалиста" : "Личный кабинет"
    }
    @Published var lastname =  ZPTextField(keyboardType: .default,
                                       title: "Фамилия*",
                                       image: nil)
    
    @Published var firstname =  ZPTextField(keyboardType: .default,
                                        title: "Имя и отчество*",
                                        image: nil)
    
    @Published var phoneField = ZPTextField(keyboardType: .phonePad,
                                        title: "Контактный номер",
                                        image: "phone")
    
    @Published var mailField = ZPTextField(keyboardType: .emailAddress,
                                        title: "Электронная почта*",
                                        image: "mail")
    
    @Published var contactMailField = ZPTextField(keyboardType: .emailAddress,
                                        title: "Контактная почта",
                                        image: "mail")
    
    @Published var aboutField = ZPTextField(keyboardType: .default,
                                        title: "Расскажите о себе",
                                        image: nil)
    @Published var town: Reference? = nil
    
    func locationBy(_ id: Int) -> Reference? {
        locations.first(where: {$0.refKeyId == id})
    }
    func configure(with person: Person) {
        self.person = person
        lastname.text = person.lastName ?? ""
        firstname.text = person.firstName ?? ""
        
        guard let image = person.photoFileId else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://zanpro-dev.alseco.kz/api/zanpro-files/internal/v1/file/\(image)/download")!)
                let (data2, _) = try await RESTClient.shared.GET(path: "/zanpro-refs/api/v1/refs/locations/ref-values?size=1000", headers: [:])
                let response: LocationResponse? = try? JSONDecoder().decode(LocationResponse.self, from: data2)
                DispatchQueue.main.async {
                    self.uiImage = UIImage(data: data)
                    let content = response?.content ?? []
                    self.locations = content.sorted(by: {$0.valueRu < $1.valueRu})
                    self.town = self.locationBy(self.person.locationRefKeyId ?? 0)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAvatar() {
        Task {
            do {
                let (_, code) = try await RESTClient.shared.DELETE(path: "/zanpro-api/api/v1/person/photo")
                if code == 200 {
                    DispatchQueue.main.async {
                        self.uiImage = nil
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveAvatar() {
        person.firstName = firstname.text
        person.lastName = lastname.text
        if let town = town {
            person.locationRefKeyId = town.refKeyId
        }
        guard uiImage != nil else { return }
        Task {
            do {
                try await RESTClient.shared.savePerson(body: person)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func format(_ value: String) {
        phoneField.text = value.phoneFormat()
    }
}


extension String {
    func phoneFormat(mask: String = "+X (XXX) XXX-XX-XX") -> String {
        let numbers = (count == 1 ? "7" : "") + onlyDigit()
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func onlyDigit() -> String {
        self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
}

struct LocationResponse: Codable {
    let content: [Reference]
}

struct Reference: Codable, Identifiable {
    var id: Int { refKeyId }
    let refKeyId: Int
    let refKeyCodeName: String
    let valueRu: String
    let valueKz: String
    let shortValueRu: String
    let shortValueKz: String
    
    enum CodingKeys: String, CodingKey {
        case refKeyId, refKeyCodeName, valueRu, valueKz, shortValueRu, shortValueKz
    }
    
    var childs: [Child] = []
}

struct ChildResponse: Codable {
    let content: [Child]
}

struct Child: Codable {
    let valueRu: String
    let valueKz: String
    let shortValueRu: String
    let shortValueKz: String
    let sourceKeyCodeName: String
    let targetKeyId: Int
    let targetKeyCodeName: String
}
