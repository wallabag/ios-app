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
}

final class WallabagApi {
    static fileprivate var endpoint: String?
    static fileprivate var clientId: String?
    static fileprivate var clientSecret: String?
    static fileprivate var username: String?
    static fileprivate var password: String?
    static fileprivate var configured: Bool = false

    static fileprivate var access_token: String?

    static var mode: RetrieveMode = .allArticles

    static func configureApi(endpoint: String, clientId: String, clientSecret: String, username: String, password: String) {
        self.endpoint = endpoint
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.username = username
        self.password = password

        configured = true
    }

    static func requestToken(_ completion: @escaping(_ success: Bool) -> ()) {
        let parameters = ["grant_type": "password", "client_id": clientId!, "client_secret": clientSecret!, "username": username!, "password": password!]

        Alamofire.request(endpoint! + "/oauth/v2/token", method: .post, parameters: parameters).validate().responseJSON { response in

            if response.result.error != nil {
                completion(false)
            }

            if let result = response.result.value {
                let JSON = result as! [String: Any]
                if let token = JSON["access_token"] as? String {
                    access_token = token
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    // MARK: - Article
    static func patchArticle(_ article: Article, withParamaters withParameters: [String: Any], completion: @escaping(_ article: Article) -> Void) {
        var parameters: [String: Any] = ["access_token": access_token!]
        parameters = parameters.merge(dict: withParameters)

        Alamofire.request(endpoint! + "/api/entries/" + String(article.id), method: .patch, parameters: parameters).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                completion(Article(fromDictionary: JSON))
            }
        }
    }

    static func deleteArticle(_ article: Article, completion: @escaping() -> Void) {
        let parameters: [String: Any] = ["access_token": access_token!]

        Alamofire.request(endpoint! + "/api/entries/" + String(article.id), method: .delete, parameters: parameters).responseJSON { response in

            completion()

        }
    }

    static func retrieveArticle(page: Int = 1, withParameters: [String: Any] = [:], _ completion: @escaping([Article]) -> Void) {
        var parameters: [String: Any] = ["access_token": access_token!, "perPage": 20, "page": page]
        parameters = parameters.merge(dict: withParameters).merge(dict: getRetrieveMode())

        var articles = [Article]()

        Alamofire.request(endpoint! + "/api/entries", parameters: parameters).responseJSON { response in
            if let result = response.result.value {
                if let JSON = result as? [String: Any] {
                    if let embedded = JSON["_embedded"] as? [String: Any] {
                        for item in embedded["items"] as! [[String: Any]] {
                            articles.append(Article(fromDictionary: item))
                        }
                    }
                }
            }
            completion(articles)
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
