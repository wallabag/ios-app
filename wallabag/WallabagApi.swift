//
//  WallabagApi.swift
//  wallabag
//
//  Created by maxime marinel on 20/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import Alamofire

final class WallabagApi {
    static fileprivate var endpoint: String?
    static fileprivate var clientId: String?
    static fileprivate var clientSecret: String?
    static fileprivate var username: String?
    static fileprivate var password: String?
    static fileprivate var configured: Bool = false

    static fileprivate var access_token: String?

    static func configureApi(endpoint: String, clientId: String, clientSecret: String, username: String, password: String) {
        self.endpoint = endpoint
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.username = username
        self.password = password

        configured = true
    }

    static func requestToken(_ completion: @escaping() -> ()) {
        let parameters = ["grant_type": "password", "client_id": clientId!, "client_secret": clientSecret!, "username": username!, "password": password!]

        Alamofire.request(endpoint! + "/oauth/v2/token", parameters: parameters).responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary

                if let token = JSON["access_token"] as? String {
                    access_token = token

                    completion()
                }
            }
        }
    }

    static func retrieveArticle(_ completion: @escaping([Article]) -> Void) {
        let parameters = ["access_token": access_token!]
        var articles = [Article]()

        Alamofire.request(endpoint! + "/api/entries.html", parameters: parameters).responseJSON { response in
            if let result = response.result.value {
                if let JSON = result as? NSDictionary {
                    if let embedded = JSON["_embedded"] as? [String: Any] {
                        for item in embedded["items"] as! [[String: Any]] {
                            articles.append(Article(fromItem: item))
                        }
                    }
                }
            }
            completion(articles)
        }
    }
}
