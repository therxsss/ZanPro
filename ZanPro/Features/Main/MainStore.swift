import Foundation

enum MainEvent {
    case recieve(Person)
}

enum MainAction {
    case fetchPerson
}

final class MainStore: Store<MainEvent, MainAction> {
    override func handleActions(_ action: MainAction) {
        switch action {
        case .fetchPerson:
            statefulCall {
                try await self.fetchPerson()
            }
        }
    }
    
    private func fetchPerson() async throws {
        do {
            let person: Person = try await RESTClient.shared.firstGet(path: "/zanpro-api/api/v1/person")
            
            sendEvent(.recieve(person))
        } catch {
            print(error.localizedDescription)
        }
    }
}


