//
//  WallabagEntry.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Foundation

enum WallabagEntryEndpoint: WallabagKitEndpoint {
    case get

    func method() -> HttpMethod {
        .get
    }

    func endpoint() -> String {
        "/api/entries.json?perPage=1"
    }

    func getBody() -> Data {
        "".data(using: .utf8)!
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
