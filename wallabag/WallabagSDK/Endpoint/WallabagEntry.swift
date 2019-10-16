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
    
    func method() -> HttpMethod {
        switch self {
        case .get:
            return .get
        case .add:
            return .post
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
            return "/api/entries.json"
        }
    }
    
    func getBody() -> Data {
        switch self {
        case let .add(url):
            return "url=\(url)".data(using: .utf8)!
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
    // public let tags: [WallabagKitTag]?
}
