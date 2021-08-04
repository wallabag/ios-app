import Foundation

public struct WallabagEntry: Decodable {
    public let id: Int
    public let userId: Int?
    public let uid: String?
    public let title: String?
    public let url: String?
    public let isArchived: Int
    public let isStarred: Int
    public let content: String?
    public let createdAt: String
    public let updatedAt: String
    public let mimetype: String?
    public let language: String?
    public let readingTime: Int?
    public let domainName: String?
    public let previewPicture: String?
    public let tags: [WallabagTag]?
}
