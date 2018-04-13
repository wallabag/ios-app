//
//  WallabagKit.swift
//  wallabag
//
//  Created by maxime marinel on 13/03/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import Alamofire

extension NSNotification.Name {
    static let wallabagkitAuthSuccess = NSNotification.Name("wallabagkit.auth.success")
}

class WallabagKit {
    static var instance = WallabagKit()
    var host: String?
    var clientID: String?
    var clientSecret: String?
    var accessToken: String? {
        didSet {
            if let accessToken = accessToken {
                self.sessionManager.adapter = TokenAdapter(accessToken: accessToken)
            }
        }
    }
    var sessionManager: SessionManager = SessionManager()
    private init() {

    }

    func requestAuth(username: String, password: String, completion: @escaping (WallabagAuth) -> Void) {
        guard let host = self.host,
            let clientID = self.clientID,
            let clientSecret = self.clientSecret else {
            return //Todo error
        }

        let parameters = [
            "grant_type": "password",
            "client_id": clientID,
            "client_secret": clientSecret,
            "username": username,
            "password": password
        ]

        Alamofire.request("\(host)/oauth/v2/token", method: .post, parameters: parameters)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    if 400 == response.response?.statusCode {
                        let result = try! JSONDecoder().decode(WallabagError.self, from: data)
                        completion(.error(result))
                    } else {
                        let result = try! JSONDecoder().decode(WallabagAuthSuccess.self, from: data)
                        self.accessToken = result.accessToken
                        completion(.success(result))
                        NotificationCenter.default.post(name: .wallabagkitAuthSuccess, object: nil)
                    }
                default:
                    print(response)
                    break
                }
            })
    }

    func entry(parameters: Parameters = [:], queue: DispatchQueue?, completion: @escaping (WallabagKitCollectionResponse<WallabagKitEntry>) -> Void) {
        sessionManager.request("\(host!)/api/entries", parameters: parameters)
            .validate()
            .responseData(queue: queue) { response in
                switch response.result {
                case .success(let data):
                    let result = try! JSONDecoder().decode(WallabagKitCollection<WallabagKitEntry>.self, from: data)
                    completion(.success(result))
                case .failure:
                    //completion(.error)
                    break
                }
        }
    }

    public func entry(add url: URL, queue: DispatchQueue?, completion: @escaping (WallabagKitResponse<WallabagKitEntry>) -> Void) {
        sessionManager.request("\(host!)/api/entries", method: .post, parameters: ["url": url.absoluteString]).validate().responseData(queue: queue) { response in
            switch response.result {
            case .success(let data):
                let result = try! JSONDecoder().decode(WallabagKitEntry.self, from: data)
                completion(.success(result))
            case .failure:
                break
            }
        }
    }

    public func entry(delete id: Int, completion: @escaping () -> Void) {
        sessionManager.request("\(host!)/api/entries/\(id)", method: .delete)
            .validate()
            .responseData { _ in
            completion()
        }
    }

    public func entry(update id: Int, parameters: Parameters = [:], queue: DispatchQueue?, completion: @escaping (WallabagKitResponse<WallabagKitEntry>) -> Void) {
        sessionManager.request("\(host!)/api/entries/\(id)", method: .patch, parameters: parameters)
            .validate().responseData(queue: queue) { response in
            switch response.result {
            case .success(let data):
                let result = try! JSONDecoder().decode(WallabagKitEntry.self, from: data)
                completion(.success(result))
                break
            case .failure:
                break
            }
        }
    }
}

struct WallabagKitEntry: Codable {
    let id: Int
    let userId: Int?
    let uid: String?
    let title: String?
    let url: String?
    let isArchived: Int
    let isStarred: Int
    let content: String?
    let createdAt: String
    let updatedAt: String
    let mimetype: String?
    let language: String?
    let readingTime: Int?
    let domainName: String?
    let previewPicture: String?
    let isPublic: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case uid
        case title
        case url
        case isArchived = "is_archived"
        case isStarred = "is_starred"
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mimetype
        case language
        case readingTime = "reading_time"
        case domainName = "domain_name"
        case previewPicture = "preview_picture"
        case isPublic = "is_public"
    }
}

struct WallabagKitCollection<T: Decodable>: Decodable {
    let limit: Int
    let page: Int
    let pages: Int
    let total: Int
    let items: [T]

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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let embeddedContainer = try container.nestedContainer(keyedBy: EmbeddedItems.self, forKey: .embedded)
        limit = try container.decode(Int.self, forKey: .limit)
        page = try container.decode(Int.self, forKey: .page)
        pages = try container.decode(Int.self, forKey: .pages)
        total = try container.decode(Int.self, forKey: .total)
        items = try embeddedContainer.decode([T].self, forKey: .items)
    }
}

enum WallabagKitResponse<T: Decodable> {
    case success(T)
    case error(WallabagError)
}

enum WallabagKitCollectionResponse<T: Decodable> {
    case success(WallabagKitCollection<T>)
    case error(WallabagError)
}

enum WallabagAuth {
    case success(WallabagAuthSuccess)
    case error(WallabagError)
}

struct WallabagAuthSuccess: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
    }
}

struct WallabagError: Codable {
    let error: String
    let description: String
    enum CodingKeys: String, CodingKey {
        case error
        case description = "error_description"
    }
}

class TokenAdapter: RequestAdapter {
    let accessToken: String
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
