import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var editMode = true
    @Published var locations: [Reference] = []
    @Published var specializations: [Reference] = []
    @Published var areas: [Reference] = []
    @Published var offers: [Reference] = []
    @Published var selectedSpecializations: Set<Int> = []
    @Published var person = Person()
    @Published var legals: [Legal] = []
    @Published var uiImage: UIImage? = nil
    @Published var editImage: UIImage? = nil
    var emptyLegals = true
    var showImage: UIImage? {
        editImage == nil ? uiImage : editImage
    }
    @Published var focusedField: ZPTextFieldType? = nil
    @Published var town: Reference? = nil
    
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

    @Published var specialization: Reference? = nil
    @Published var license = ZPTextField(keyboardType: .default,
                                     title: "№ лицензии*",
                                     image: nil)
    @Published var date = Date()
    var presentPhotoPicker: VoidCallback?
    var deleteAvatar: VoidCallback?
    var saveAvatar: ((UIImage) -> Void)?
    var savePerson: ((Person) -> Void)?
    var saveLegals: (([Legal]) -> Void)?
    var saveLegal: ((Legal) -> Void)?
    var updateRegEmail: ((String) -> Void)?
    var updateRegMobile: ((String) -> Void)?
    var deleteLegal: ((Int) -> Void)?
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
    var titleField: String {
        editMode ? "Регистрация специалиста" : "Личный кабинет"
    }
    
    private func locationBy(_ id: Int?) -> Reference? {
        locations.first(where: {$0.refKeyId == id})
    }
    
    func configure(with person: Person) {
        self.person = person
        lastname.text = person.lastName ?? ""
        firstname.text = person.firstName ?? ""
        town = locationBy(person.locationRefKeyId)
        mailField.text = person.email ?? ""
        aboutField.text = person.about ?? ""
    }
    
    func configure(with legals: [Legal]) {
        emptyLegals = legals.isEmpty
        self.legals = emptyLegals ? [Legal(license: "", careerStartDate: "", activityAreasWithOffers: [])] : legals
        selectedSpecializations.removeAll()
        for index in legals.indices {
            if let id = legals[index].specializationRefKeyId {
                selectedSpecializations.insert(id)
            }
            self.legals[index].startDate = Date.dateFromISOString(legals[index].careerStartDate) ?? Date()
        }
        print(selectedSpecializations)
    }
    
    func configure(with image: UIImage) {
        uiImage = image
    }
    
    func configure(with locations: [Reference]) {
        self.locations = locations
        if town == nil {
            town = locationBy(person.locationRefKeyId)
        }
    }
    
    func configureSpecializations(_ specializations: [Reference]) {
        self.specializations = specializations
    }
    
    func configureAreas(_ areas: [Reference]) {
        self.areas = areas
    }
    
    func areaOffers(_ id: Int) -> [Child] {
        guard let area = areas.first(where: { id == $0.refKeyId }) else { return [] }
        return area.childs
    }
    func configureOffers(_ offers: [Reference]) {
        self.offers = offers
    }
    
    func removeAvatar() {
        if editImage == nil {
            uiImage = nil
        } else {
            editImage = nil
        }
    }
    
    func addAvatar(_ image: UIImage) {
        editImage = image
    }
    
    func save() {
        for index in legals.indices {
            legals[index].careerStartDate = Date.stringFromISODate(legals[index].startDate)
        }
        print("!!!!!", legals)
        if person.photoFileId != nil && uiImage == nil {
            deleteAvatar?()
        } else if let editImage {
            saveAvatar?(editImage)
        }
        var newPerson = person
        newPerson.firstName = firstname.text
        newPerson.lastName = lastname.text
        newPerson.locationRefKeyId = town?.refKeyId
        newPerson.about = aboutField.text
            newPerson.pendingEmails.append(contactMailField.text)
        savePerson?(newPerson)
            saveLegals?(legals)

    }
    
    func locationBy(_ id: Int) -> Reference? {
        locations.first(where: {$0.refKeyId == id})
    }
    
    func format(_ value: String) {
        phoneField.text = value.phoneFormat()
    }
    
    func updateRegMail() {
        if mailField.text.lowercased() != person.email?.lowercased() {
            updateRegEmail?(mailField.text)
        } else {
            print("DEBUG: не удалось поменять")
        }
    }
    
    var specializationMenu: [Reference] {
        specializations.filter { !selectedSpecializations.contains($0.refKeyId) }
    }
    
    var canAddSpecialization: Bool {
        legals.last?.specializationRefKeyId != nil && selectedSpecializations.count < specializations.count
    }
    
    func specializationAreas(_ legal: Legal) -> [Child] {
        guard let specialization = specializations.first(where: { $0.refKeyId == legal.keyId}) else { return []}
        return specialization.childs.filter { child in
            legal.activityAreasWithOffers.first { $0.activityAreaId == child.targetKeyId } == nil ? true : false
        }
    }
    
    func offerTitle(_ id: Int) -> String {
        offers.first { $0.refKeyId == id }?.shortValueRu ?? ""
    }
    
    func areaTitle(_ id: Int) -> String {
        areas.first { $0.refKeyId == id }?.valueRu ?? ""
    }
    func specializationTitle(_ legal: Legal) -> String {
        specializations.first { $0.refKeyId == legal.specializationRefKeyId}?.valueRu ?? ""
    }
    
    func removeSpecialization(at index: Int) {
        let legal = legals.remove(at: index)
        if let id = legal.id {
            deleteLegal?(id)
        }
        guard let keyId = legal.specializationRefKeyId else { return }
        selectedSpecializations.remove(keyId)
    }
    
    func addSpecialization(at index: Int, id: Int) {
        guard !legals.isEmpty else { return }
        if let keyId = legals[index].specializationRefKeyId {
            legals[index].activityAreasWithOffers = []
            legals[index].id = nil
            selectedSpecializations.remove(keyId)
        }
        legals[index].specializationRefKeyId = id
        selectedSpecializations.insert(id)
    }
    
    func addArea(at index: Int, id: Int) {
        guard let activity = areas.first(where: { $0.refKeyId == id}) else { return }
        let keyIds = activity.childs.map({ $0.targetKeyId })
        legals[index].activityAreasWithOffers.append(Offers(activityAreaId: id, offerRefKeyIds: keyIds))
    }
    
    func removeArea(at index: Int, id: Int) {
        if let areaIndex = legals[index].activityAreasWithOffers.firstIndex(where: { $0.activityAreaId == id }) {
            legals[index].activityAreasWithOffers.remove(at: areaIndex)
        }
    }
}
