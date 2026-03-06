import CoreData
import CoreSpotlight
import Foundation
import HTMLEntities
import SharedLib

// import MobileCoreServices
import WallabagKit

class Entry: NSManagedObject, Identifiable {}

extension Entry {
    @nonobjc class func fetchRequestSorted() -> NSFetchRequest<Entry> {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    @nonobjc class func fetchOneById(_ id: Int) -> NSFetchRequest<Entry> {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        return fetchRequest
    }

    @NSManaged dynamic var content: String?
    @NSManaged dynamic var createdAt: Date?
    @NSManaged dynamic var domainName: String?
    @NSManaged dynamic var id: Int
    @NSManaged dynamic var isArchived: Bool
    @NSManaged dynamic var isStarred: Bool
    @NSManaged dynamic var previewPicture: String?
    @NSManaged dynamic var title: String?
    @NSManaged dynamic var updatedAt: Date?
    @NSManaged dynamic var url: String?
    @NSManaged dynamic var readingTime: Int
    @NSManaged dynamic var screenPosition: Float
    @NSManaged var tags: Set<Tag>
}

extension Entry {
    var spotlightIdentifier: String {
        "\(Bundle.main.bundleIdentifier!).spotlight.\(Int(id))"
    }

    /* var searchableItemAttributeSet: CSSearchableItemAttributeSet {
         let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
         searchableItemAttributeSet.title = title
         searchableItemAttributeSet.contentDescription = content?.withoutHTML

         return searchableItemAttributeSet
     } */

    func hydrate(from article: WallabagEntry) {
        id = article.id
        title = article.title
        content = article.content
        createdAt = Date.fromISOString(article.createdAt)
        updatedAt = Date.fromISOString(article.updatedAt)
        domainName = article.domainName
        isArchived = article.isArchived.bool
        isStarred = article.isStarred.bool
        previewPicture = article.previewPicture
        url = article.url
        readingTime = article.readingTime ?? 0
    }

    func toggleArchive() {
        isArchived.toggle()
        objectWillChange.send()
    }

    func toggleStarred() {
        isStarred.toggle()
        objectWillChange.send()
    }

    var screenPositionForWebView: Double {
        if screenPosition < 0 {
            return 0.0
        }
        return Double(screenPosition)
    }

    var titleHtml: String {
        let escapedTitle = (title ?? "").htmlEscape()
        return "<h1>\(escapedTitle)</h1>"
    }
}
