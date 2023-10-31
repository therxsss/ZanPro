import UIKit
import CoreData

final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() {}

    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createPhoto(_ id: Int16, title: String, url: String?) {
        guard let photoEntityDescription = NSEntityDescription.entity(forEntityName: "Photo", in: context) else {
            return
        }
        let photo = Photo(entity: photoEntityDescription, insertInto: context)
        photo.id = id
        photo.title = title
        photo.url = url

        appDelegate.saveContext()
    }
    
    public func fetchPhotos() -> [Photo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            return (try? context.fetch(fetchRequest) as? [Photo]) ?? []
        }
    }

    public func fetchPhoto(with id: Int16) -> Photo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let photos = try? context.fetch(fetchRequest) as? [Photo]
            return photos?.first
        }
    }

    public func updataPhoto(with id: Int16, newUrl: String, title: String? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let photos = try? context.fetch(fetchRequest) as? [Photo],
                  let photo = photos.first else { return }
            photo.url = newUrl
            photo.title = title
        }

        appDelegate.saveContext()
    }

    public func deleteAllPhoto() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            let photos = try? context.fetch(fetchRequest) as? [Photo]
            photos?.forEach { context.delete($0) }
        }

        appDelegate.saveContext()
    }

    public func deletaPhoto(with id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let photos = try? context.fetch(fetchRequest) as? [Photo],
                  let photo = photos.first else { return}
            context.delete(photo)
        }

        appDelegate.saveContext()
    }
}

//MARK: - PersonLocal
extension CoreDataManager {
    public func createPersonLocal(with image: UIImage) {
        guard let personEntityDescription = NSEntityDescription.entity(forEntityName: "PersonLocal", in: context)
        else { return }
        let person = PersonLocal(
            entity: personEntityDescription,
            insertInto: context)
        person.image = image.jpegData(compressionQuality: 1)
        appDelegate.saveContext()
    }
}
