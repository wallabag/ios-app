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

    fileprivate struct Token {
        let expiresIn: Int
        let accessToken: String
        let expiresDate: Date

        init(expiresIn: Int, accessToken: String) {
            self.expiresIn = expiresIn
            self.accessToken = accessToken

            expiresDate = Calendar.current.date(byAdding: .second, value: expiresIn - 60, to: Date())!
        }

        func isValid() -> Bool {
            return expiresDate > Date()
        }
    }

    static fileprivate var endpoint: String?
    static fileprivate var clientId: String?
    static fileprivate var clientSecret: String?
    static fileprivate var username: String?
    static fileprivate var password: String?
    static fileprivate var configured: Bool = false

    static fileprivate var token: Token?

    static var mode: RetrieveMode = .allArticles

    static func configureApi(endpoint: String, clientId: String, clientSecret: String, username: String, password: String) {
        self.endpoint = endpoint
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.username = username
        self.password = password

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
                let token = JSON["access_token"] as? String,
                let expire = JSON["expires_in"] as? Int else {
                completion(false)
                return
            }

            self.token = Token(expiresIn: expire, accessToken: token)
            completion(true)
        }
    }

    fileprivate static func requestWithToken(_ completion: @escaping(_ token: Token) -> Void) {
        if self.token != nil && self.token!.isValid() {
            completion(self.token!)
        } else {
            requestToken({ success in
                if success {
                    completion(self.token!)
                } else {
                    //Fatal ?
                }
            })
        }
    }

    // MARK: - Article
    static func patchArticle(_ article: Article, withParamaters withParameters: [String: Any], completion: @escaping(_ article: Article) -> Void) {
        requestWithToken { token in
            var parameters: [String: Any] = ["access_token": token.accessToken]
            parameters = parameters.merge(dict: withParameters)

            Alamofire.request(endpoint! + "/api/entries/" + String(article.id), method: .patch, parameters: parameters).responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    completion(Article(fromDictionary: JSON))
                }
            }
        }
    }

    static func deleteArticle(_ article: Article, completion: @escaping() -> Void) {
        requestWithToken { token in
            let parameters: [String: Any] = ["access_token": token.accessToken]
            Alamofire.request(endpoint! + "/api/entries/" + String(article.id), method: .delete, parameters: parameters).responseJSON { _ in
                completion()
            }
        }
    }

    static func addArticle(_ url: URL, completion: @escaping(_ article: Article) -> Void) {
        requestWithToken { token in
            let parameters: [String: Any] = ["access_token": token.accessToken, "url": url.absoluteString]

            Alamofire.request(endpoint! + "/api/entries", method: .post, parameters: parameters).responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    completion(Article(fromDictionary: JSON))
                }
            }
        }
    }

    static func retrieveArticle(page: Int = 1, withParameters: [String: Any] = [:], _ completion: @escaping([Article]) -> Void) {
        requestWithToken { token in
            var parameters: [String: Any] = ["access_token": token.accessToken, "perPage": 20, "page": page]
            parameters = parameters.merge(dict: withParameters).merge(dict: getRetrieveMode())

            var articles = [Article]()

            Alamofire.request(endpoint! + "/api/entries", parameters: parameters).responseJSON { response in
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
