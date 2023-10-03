import CoreData
import Factory
import Foundation

@propertyWrapper
struct CoreDataViewContext {
    @Injected(\Container.coreData) private var coreData

    var wrappedValue: NSManagedObjectContext {
        coreData.viewContext
    }
}
