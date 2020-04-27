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

    func requestToken() -> AnyPublisher<WallabagToken?, WallabagKitError> {
        let urlRequest = request(for: WallabagOauth.request(
            clientId: clientId ?? "",
            clientSecret: clientSecret ?? "",
            username: username ?? "",
            password: password ?? ""
        ))

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else { fatalError() }
                if 400 ... 401 ~= response.statusCode {
                    if let jsonError = try? self.decoder.decode(WallabagJsonError.self, from: data) {
                        throw WallabagKitError.jsonError(json: jsonError)
                    } else {
                        throw WallabagKitError.unknown
                    }
                }
                return data
            }
            .decode(type: WallabagToken.self, decoder: decoder)
            .mapErrorToWallabagKitError()
            .map { token in
                self.accessToken = token.accessToken
                self.refreshToken = token.refreshToken
                return token
            }
            .eraseToAnyPublisher()
    }

    func send<T: Decodable>(to: WallabagKitEndpoint) -> AnyPublisher<T, WallabagKitError> {
        fetch(to: to)
            .decode(type: T.self, decoder: decoder)
            .mapErrorToWallabagKitError()
            .eraseToAnyPublisher()
    }

    private func fetch(to: WallabagKitEndpoint) -> AnyPublisher<Data, WallabagKitError> {
        var urlRequest = request(for: to)
        urlRequest.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else { fatalError() }

                if 401 == response.statusCode {
                    throw WallabagKitError.authenticationRequired
                }

                if 400 ... 401 ~= response.statusCode {
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
                    .tryMap { token -> AnyPublisher<Data, WallabagKitError> in
                        if token != nil {
                            return self.fetch(to: to)
                        }
                        print("Refresh failed")
                        throw WallabagKitError.unknown
                    }
                    .mapError { error in WallabagKitError.wrap(error: error) }
                    .switchToLatest()
                    .eraseToAnyPublisher()
            }
            .mapErrorToWallabagKitError()
            .eraseToAnyPublisher()
    }

    private func request(for endpoint: WallabagKitEndpoint) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: "\(host)\(endpoint.endpoint())")!)
        urlRequest.httpMethod = endpoint.method().rawValue
        urlRequest.httpBody = endpoint.getBody()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }
}
