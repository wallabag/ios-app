//
//  WallabagKit.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation

public class WallabagKit {
    typealias Parameters = [String: Any]

    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let session: URLSession
    private var cancellableSession: AnyCancellable?

    // MARK: Server information

    private var host: String

    // MARK: User information

    var clientId: String?
    var clientSecret: String?
    var username: String?
    var password: String?

    // MARK: Token

    var accessToken: String?
    var refreshToken: String?

    init(host: String, session: URLSession = .shared) {
        self.host = host
        self.session = session
    }

    // swiftlint:disable force_cast
    func getToken() -> AnyPublisher<WallabagToken, WallabagKitError> {
        let to = WallabagOauth.request(
            clientId: clientId ?? "",
            clientSecret: clientSecret ?? "",
            username: username ?? "",
            password: password ?? ""
        )
        var urlRequest = URLRequest(url: URL(string: "\(host)\(to.endpoint())")!)
        urlRequest.httpMethod = to.method().rawValue
        urlRequest.httpBody = to.getBody()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                let res = response as! HTTPURLResponse
                if 400 ... 401 ~= res.statusCode {
                    if let poc = try? self.decoder.decode(WallabagJsonError.self, from: data) {
                        throw WallabagKitError.jsonError(json: poc)
                    } else {
                        throw WallabagKitError.unknown
                    }
                }
                return data
            }
            .decode(type: WallabagToken.self, decoder: decoder)
            .mapError { error in
                if let error = error as? WallabagKitError {
                    return error
                }

                return WallabagKitError.wrap(error: error)
            }
            .eraseToAnyPublisher()
    }

    func requestToken() -> AnyPublisher<Bool, Never> {
        let to = WallabagOauth.request(
            clientId: clientId ?? "",
            clientSecret: clientSecret ?? "",
            username: username ?? "",
            password: password ?? ""
        )
        var urlRequest = URLRequest(url: URL(string: "\(host)\(to.endpoint())")!)
        urlRequest.httpMethod = to.method().rawValue
        urlRequest.httpBody = to.getBody()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return session.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: WallabagToken.self, decoder: decoder)
            .map { token -> Bool in
                self.accessToken = token.accessToken
                self.refreshToken = token.refreshToken
                return true
            }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }

    // swiftlint:disable force_cast
    func fetch(to: WallabagKitEndpoint) -> AnyPublisher<Data, WallabagKitError> {
        var urlRequest = URLRequest(url: URL(string: "\(host)\(to.endpoint())")!)
        urlRequest.httpMethod = to.method().rawValue
        urlRequest.httpBody = to.getBody()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                let res = response as! HTTPURLResponse

                if 401 == res.statusCode {
                    throw WallabagKitError.authenticationRequired
                }

                if 400 ... 401 ~= res.statusCode {
                    if let poc = try? self.decoder.decode(WallabagJsonError.self, from: data) {
                        throw WallabagKitError.jsonError(json: poc)
                    } else {
                        throw WallabagKitError.unknown
                    }
                }
                return data
            }
            .tryCatch { error in
                self.requestToken()
                    .tryMap { success -> AnyPublisher<Data, WallabagKitError> in
                        if success {
                            return self.fetch(to: to)
                        }
                        print("Refresh failed")
                        throw WallabagKitError.unknown
                    }
                    .mapError { error in WallabagKitError.wrap(error: error) }
                    .switchToLatest()
                    .eraseToAnyPublisher()
            }
            .mapError { error in
                if let error = error as? WallabagKitError {
                    return error
                }

                return WallabagKitError.wrap(error: error)
            }
            .eraseToAnyPublisher()
    }

    func send<T: Decodable>(to: WallabagKitEndpoint) -> AnyPublisher<T, WallabagKitError> {
        fetch(to: to)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if error is DecodingError {
                    return WallabagKitError.decodingJSON
                }

                return WallabagKitError.wrap(error: error)
            }
            .eraseToAnyPublisher()
    }
}
