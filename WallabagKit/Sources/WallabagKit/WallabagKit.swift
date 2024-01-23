//
//  WallabagKit.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation

public class WallabagKit {
    public typealias Parameters = [String: Any]

    public var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let session: URLSession
    private var cancellableSession: AnyCancellable?

    // MARK: Server information

    public var host: String

    // MARK: User information

    public var clientId: String?
    public var clientSecret: String?
    public var username: String?
    public var password: String?

    // MARK: Token

    public var accessToken: String?
    public var refreshToken: String?

    public init(host: String, session: URLSession = .shared) {
        self.host = host
        self.session = session
    }

    public func requestTokenAsync() async throws -> WallabagToken {
        let urlRequest = request(for: WallabagOauth.request(
            clientId: clientId ?? "",
            clientSecret: clientSecret ?? "",
            username: username ?? "",
            password: password ?? ""
        ))

        let (data, response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { fatalError() }

        try handleStatusCode(from: response, with: data)

        let token = try decoder.decode(WallabagToken.self, from: data)

        accessToken = token.accessToken
        refreshToken = token.refreshToken

        return token
    }

    public func send<T: WallabagKitEndpoint>(to: T) async throws -> T.Object {
        let (data, response) = try await session.data(for: request(for: to, withAuth: true))
        guard let response = response as? HTTPURLResponse else { fatalError() }

        try handleStatusCode(from: response, with: data)

        return try decoder.decode(T.Object.self, from: data)

//        fetch(to: to)
//            .decode(type: T.self, decoder: decoder)
//            .mapErrorToWallabagKitError()
//            .eraseToAnyPublisher()
    }

    //    private func fetch(to: WallabagKitEndpoint) -> AnyPublisher<Data, WallabagKitError> {
    //        session.dataTaskPublisher(for: request(for: to, withAuth: true))
    //            .tryMap { data, response in
    //                guard let response = response as? HTTPURLResponse else { fatalError() }
    //
    //                try self.handleStatusCode(from: response, with: data)
    //
    //                return data
    //            }
    //            .tryCatch { error in
    //                self.requestToken()
    //                    .tryMap { token -> AnyPublisher<Data, WallabagKitError> in
    //                        if token != nil {
    //                            return self.fetch(to: to)
    //                        }
    //                        throw WallabagKitError.invalidToken
    //                    }
    //                    .mapError { error in WallabagKitError.wrap(error: error) }
    //                    .switchToLatest()
    //                    .eraseToAnyPublisher()
    //            }
    //            .mapErrorToWallabagKitError()
    //            .eraseToAnyPublisher()
    //    }

//    public func send<T: Decodable>(to: WallabagKitEndpoint) -> AnyPublisher<T, WallabagKitError> {
//        fetch(to: to)
//            .decode(type: T.self, decoder: decoder)
//            .mapErrorToWallabagKitError()
//            .eraseToAnyPublisher()
//    }

//    private func fetch(to: WallabagKitEndpoint) -> AnyPublisher<Data, WallabagKitError> {
//        session.dataTaskPublisher(for: request(for: to, withAuth: true))
//            .tryMap { data, response in
//                guard let response = response as? HTTPURLResponse else { fatalError() }
//
//                try self.handleStatusCode(from: response, with: data)
//
//                return data
//            }
//            .tryCatch { error in
//                self.requestToken()
//                    .tryMap { token -> AnyPublisher<Data, WallabagKitError> in
//                        if token != nil {
//                            return self.fetch(to: to)
//                        }
//                        throw WallabagKitError.invalidToken
//                    }
//                    .mapError { error in WallabagKitError.wrap(error: error) }
//                    .switchToLatest()
//                    .eraseToAnyPublisher()
//            }
//            .mapErrorToWallabagKitError()
//            .eraseToAnyPublisher()
//    }

    public func request(for endpoint: any WallabagKitEndpoint, withAuth: Bool = false) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: "\(host)\(endpoint.endpoint())")!)
        urlRequest.httpMethod = endpoint.method().rawValue
        urlRequest.httpBody = endpoint.getBody()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if withAuth {
            urlRequest.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }

    private func handleStatusCode(from response: HTTPURLResponse, with data: Data) throws {
        if 400 ... 401 ~= response.statusCode {
            if let jsonError = try? decoder.decode(WallabagJsonError.self, from: data) {
                throw WallabagKitError.jsonError(json: jsonError)
            } else {
                throw WallabagKitError.decodingJSON
            }
        }

        if response.statusCode == 401 {
            throw WallabagKitError.authenticationRequired
        }

        if response.statusCode == 404 {
            throw WallabagKitError.invalidApiEndpoint
        }

        if response.statusCode == 500 {
            throw WallabagKitError.serverError
        }
    }
}
