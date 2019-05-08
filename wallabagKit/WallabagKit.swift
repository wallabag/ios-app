//
//  WallabagKit.swift
//  wallabag
//
//  Created by maxime marinel on 13/03/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Alamofire
import Foundation

public protocol WallabagKitProtocol {
    var accessToken: String? { get }
    func requestAuth(username: String, password: String, completion: @escaping (WallabagAuth) -> Void)
    func entry(parameters: Parameters, queue: DispatchQueue?, completion: @escaping (WallabagKitCollectionResponse<WallabagKitEntry>) -> Void)
    func entry(add url: URL, queue: DispatchQueue?, completion: @escaping (WallabagKitResponse<WallabagKitEntry>) -> Void)
    func entry(delete id: Int, completion: @escaping () -> Void)
    func entry(update id: Int, parameters: Parameters, queue: DispatchQueue?, completion: @escaping (WallabagKitResponse<WallabagKitEntry>) -> Void)
}

public class WallabagKit: WallabagKitProtocol {
    var host: String?
    var clientID: String?
    var clientSecret: String?
    public var accessToken: String? {
        didSet {
            if let accessToken = accessToken {
                WallabagKit.sessionManager.adapter = TokenAdapter(accessToken: accessToken)
            }
        }
    }

    static let sessionManager: SessionManager = SessionManager()

    public init(host: String, clientID: String, clientSecret: String) {
        self.host = host
        self.clientID = clientID
        self.clientSecret = clientSecret
    }

    public static func getVersion(from host: String, completion: @escaping (WallabagVersion) -> Void) {
        Alamofire.request("\(host)/api/version", method: .get)
            .responseString { response in
                guard let body = response.result.value else { completion(WallabagVersion(version: "unknown"))
                    return
                }

                let version = WallabagVersion(version: body)
                completion(version)
            }
    }

    init() {}

    public func requestAuth(username: String, password: String, completion: @escaping (WallabagAuth) -> Void) {
        guard let host = self.host,
            let clientID = self.clientID,
            let clientSecret = self.clientSecret else {
            completion(.invalidParameter)
            return
        }

        let parameters = [
            "grant_type": "password",
            "client_id": clientID,
            "client_secret": clientSecret,
            "username": username,
            "password": password,
        ]

        Alamofire.request("\(host)/oauth/v2/token", method: .post, parameters: parameters)
            .responseData { response in
                switch response.result {
                case let .success(data):
                    if 400 == response.response?.statusCode {
                        guard let result = try? JSONDecoder().decode(WallabagAuthError.self, from: data) else {
                            completion(.unexpectedError)
                            return
                        }
                        completion(.error(result))
                        NotificationCenter.default.post(name: .wallabagkitAuthError, object: result)
                    } else {
                        guard let result = try? JSONDecoder().decode(WallabagAuthSuccess.self, from: data) else {
                            completion(.unexpectedError)
                            return
                        }
                        self.accessToken = result.accessToken
                        completion(.success(result))
                        NotificationCenter.default.post(name: .wallabagkitAuthSuccess, object: nil)
                    }
                default:
                    completion(.unexpectedError)
                }
            }
    }

    public func entry(parameters: Parameters = [:], queue: DispatchQueue?, completion: @escaping (WallabagKitCollectionResponse<WallabagKitEntry>) -> Void) {
        WallabagKit.sessionManager.request("\(host!)/api/entries", parameters: parameters)
            .validate(statusCode: 200 ..< 500)
            .responseData(queue: queue) { response in
                switch response.result {
                case let .success(data):
                    guard let result = try? JSONDecoder().decode(WallabagKitCollection<WallabagKitEntry>.self, from: data) else {
                        completion(.error(WallabagError.invalidJSON))
                        return
                    }

                    completion(.success(result))
                case let .failure(error):
                    completion(.error(error))
                }
            }
    }

    public func entry(add url: URL, queue: DispatchQueue?, completion: @escaping (WallabagKitResponse<WallabagKitEntry>) -> Void) {
        WallabagKit.sessionManager.request("\(host!)/api/entries", method: .post, parameters: ["url": url.absoluteString]).responseData(queue: queue) { response in
            switch response.result {
            case let .success(data):
                guard let result = try? JSONDecoder().decode(WallabagKitEntry.self, from: data) else {
                    completion(.error(WallabagError.invalidJSON))
                    return
                }
                completion(.success(result))
            case .failure:
                completion(.error(WallabagError.unexpectedError))
            }
        }
    }

    public func entry(delete id: Int, completion: @escaping () -> Void) {
        WallabagKit.sessionManager.request("\(host!)/api/entries/\(id)", method: .delete)
            .validate()
            .responseData { _ in
                completion()
            }
    }

    public func entry(update id: Int, parameters: Parameters = [:], queue: DispatchQueue?, completion: @escaping (WallabagKitResponse<WallabagKitEntry>) -> Void) {
        WallabagKit.sessionManager.request("\(host!)/api/entries/\(id)", method: .patch, parameters: parameters)
            .validate().responseData(queue: queue) { response in
                switch response.result {
                case let .success(data):
                    guard let result = try? JSONDecoder().decode(WallabagKitEntry.self, from: data) else {
                        completion(.error(WallabagError.invalidJSON))
                        return
                    }
                    completion(.success(result))
                case .failure:
                    completion(.error(WallabagError.unexpectedError))
                }
            }
    }
}
