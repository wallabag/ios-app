import CoreData
import Foundation

@propertyWrapper
struct CoreDataViewContext {
    var wrappedValue: NSManagedObjectContext {
        CoreData.shared.viewContext
    }
}
