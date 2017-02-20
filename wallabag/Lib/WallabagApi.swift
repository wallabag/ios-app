//
//  WallabagApi.swift
//  wallabag
//
//  Created by maxime marinel on 20/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import Alamofire

enum RetrieveMode: String {
    case allArticles
    case archivedArticles
    case unarchivedArticles
    case starredArticles

    func humainReadable() -> String {
        switch self {
        case .allArticles:
            return "All articles"
        case .archivedArticles:
            return "Read articles"
        case .starredArticles:
            return "Starred articles"
        case .unarchivedArticles:
            return "Unread articles"
        }
    }
}

final class WallabagApi {

    static fileprivate let sessionManager = SessionManager()

    static fileprivate var endpoint: String?
    static fileprivate var clientId: String?
    static fileprivate var clientSecret: String?
    static fileprivate var username: String?
    static fileprivate var password: String?
    static fileprivate var configured: Bool = false

    static var mode: RetrieveMode = .allArticles

    static func configureApi(from server: Server) {
        self.endpoint = server.host
        self.clientId = server.client_id
        self.clientSecret = server.client_secret
        self.username = server.username
        self.password = server.password

        configured = true
    }

    static func requestToken(_ completion: @escaping(_ success: Bool) -> Void) {
        let parameters = ["grant_type": "password", "client_id": clientId!, "client_secret": clientSecret!, "username": username!, "password": password!]

        Alamofire.request(endpoint! + "/oauth/v2/token", method: .post, parameters: parameters).validate().responseJSON { response in
            if response.result.error != nil {
                completion(false)
            }

            guard let result = response.result.value,
                let JSON = result as? [String: Any],
                let accessToken = JSON["access_token"] as? String,
                let refreshToken = JSON["refresh_token"] as? String else {
                    return
            }

            let bearer = BearerTokenAdapter(clientID: clientId!, clientSecret: clientSecret!, username: username!, password: password!, baseURLString: endpoint!, accessToken: accessToken, refreshToken: refreshToken)
            sessionManager.adapter = bearer
            sessionManager.retrier = bearer

            completion(true)
        }
    }

    // MARK: - Article
    static func patchArticle(_ article: Article, withParamaters withParameters: [String: Any], completion: @escaping(_ article: Article) -> Void) {
        sessionManager.request(endpoint! + "/api/entries/" + String(article.id), method: .patch, parameters: withParameters)
            .validate()
            .responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    completion(Article(fromDictionary: JSON))
                }
        }
    }

    static func deleteArticle(_ article: Article, completion: @escaping() -> Void) {
        sessionManager.request(endpoint! + "/api/entries/" + String(article.id), method: .delete).validate().responseJSON { _ in
            completion()
        }
    }

    static func addArticle(_ url: URL, completion: @escaping(_ article: Article) -> Void) {
        sessionManager.request(endpoint! + "/api/entries", method: .post, parameters: ["url": url.absoluteString]).validate().responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                completion(Article(fromDictionary: JSON))
            }
        }
    }

    static func retrieveArticle(page: Int = 1, withParameters: [String: Any] = [:], _ completion: @escaping([Article]) -> Void) {
        var parameters: [String: Any] = ["perPage": 20, "page": page]
        parameters = parameters.merge(dict: withParameters).merge(dict: getRetrieveMode())
        var articles = [Article]()

        sessionManager.request(endpoint! + "/api/entries", parameters: parameters).validate().responseJSON { response in
            if let result = response.result.value {
                if let JSON = result as? [String: Any] {
                    if let embedded = JSON["_embedded"] as? [String: Any] {
                        for item in (embedded["items"] as? [[String: Any]])! {
                            articles.append(Article(fromDictionary: item))
                        }
                    }
                }
            }
            completion(articles)
        }
    }

    static func retrieveUnreadArticle(_ completion: @escaping(_ total: Int) -> Void) {
        let parameters: [String: Any] = ["perPage": 99, "archive": 0]
        var total = 0

        sessionManager.request(endpoint! + "/api/entries", parameters: parameters).validate().responseJSON { response in
            if let result = response.result.value {
                if let JSON = result as? [String: Any] {
                    if let embedded = JSON["_embedded"] as? [String: Any] {
                        if let items = embedded["items"] as? [[String: Any]] {
                            total = items.count
                        }
                    }
                }
            }
            completion(total)
        }
    }

    static func getRetrieveMode() -> [String: Any] {
        switch mode {
        case .allArticles:
            return [:]
        case .archivedArticles:
            return ["archive": 1]
        case .unarchivedArticles:
            return ["archive": 0]
        case .starredArticles:
            return ["starred": 1]
        }
    }
}
