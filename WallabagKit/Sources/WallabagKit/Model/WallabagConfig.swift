import Foundation

public struct WallabagConfig: Decodable {
    public let id: Int
    public let itemsPerPage: Int
    public let language: String
    public let feedLimit: Int
    public let readingSpeed: Double
    public let actionMarkAsRead: Int
    public let listMode: Int
}
