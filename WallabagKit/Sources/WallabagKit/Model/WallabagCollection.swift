import Foundation

public struct WallabagCollection<T: Decodable>: Decodable {
    public let limit: Int
    public let page: Int
    public let pages: Int
    public let total: Int
    public let items: [T]

    enum CodingKeys: String, CodingKey {
        case limit
        case page
        case pages
        case total
        case embedded = "_embedded"
    }

    enum EmbeddedItems: String, CodingKey {
        case items
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let embeddedContainer = try container.nestedContainer(keyedBy: EmbeddedItems.self, forKey: .embedded)
        limit = try container.decode(Int.self, forKey: .limit)
        page = try container.decode(Int.self, forKey: .page)
        pages = try container.decode(Int.self, forKey: .pages)
        total = try container.decode(Int.self, forKey: .total)
        items = try embeddedContainer.decode([T].self, forKey: .items)
    }
}
