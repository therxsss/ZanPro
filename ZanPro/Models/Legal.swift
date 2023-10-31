import Foundation

struct Legal: Codable {
    var id: Int?
    var license: String
    var specializationRefKeyId: Int?
    var careerStartDate: String
    var activityAreasWithOffers: [Offers]
    
    var keyId: Int {
        specializationRefKeyId ?? 0
    }
    var startDate = Date()
    
    enum CodingKeys: String, CodingKey {
        case id, license, specializationRefKeyId, careerStartDate, activityAreasWithOffers
    }
}

struct Offers: Codable, Identifiable {
    let activityAreaId: Int
    var id: Int { activityAreaId }
    var offerRefKeyIds: [Int]
}

struct LegalResponse: Codable {
    let onVerification: Legal?
}
