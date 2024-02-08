import Foundation

public struct WallabagTag: Decodable, Sendable {
    public let id: Int
    public let label: String
    public let slug: String
}
