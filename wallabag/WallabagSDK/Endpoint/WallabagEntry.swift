//
//  WallabagEntry.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Foundation

enum WallabagEntryEndpoint: WallabagKitEndpoint {
    case get(page: Int = 1, perPage: Int = 30)
    case add(url: String)
    case addTag(tag: String, entry: Int)
    case delete(id: Int)
    case deleteTag(tagId: Int, entry: Int)
    case update(id: Int, parameters: WallabagKit.Parameters)

    func method() -> HttpMethod {
        switch self {
        case .get:
            return .get
        case .add, .addTag:
            return .post
        case .delete, .deleteTag:
            return .delete
        case .update:
            return .patch
        }
    }

    func endpoint() -> String {
        switch self {
        case let .get(page, perPage):
            var request = URLComponents()
            request.path = "/api/entries.json"
            request.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "perPage", value: "\(perPage)"),
            ]
            return request.url!.relativeString
        case .add:
            return "/api/entries"
        case let .addTag(_, entry):
            return "/api/entries/\(entry)/tags"
        case let .delete(id):
            return "/api/entries/\(id)"
        case let .deleteTag(tagId, entryId):
            return "/api/entries/\(entryId)/tags/\(tagId)"
        case let .update(id, _):
            return "/api/entries/\(id).json"
        }
    }

    //swiftlint:disable force_try
    func getBody() -> Data {
        switch self {
        case let .add(url):
            return try! JSONSerialization.data(withJSONObject: ["url": url], options: .prettyPrinted)
        case let .update(_, parameters):
            return try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        case let .addTag(tag, _):
            return try! JSONSerialization.data(withJSONObject: ["tags": tag], options: .prettyPrinted)
        default:
            return "".data(using: .utf8)!
        }
    }

    func requireAuth() -> Bool {
        true
    }
}

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
