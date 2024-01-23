//
//  WallabagKitEndpoint.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Foundation

public protocol WallabagKitEndpoint {
    associatedtype Object: Decodable
    func method() -> HttpMethod
    func endpoint() -> String
    func getBody() -> Data
    func requireAuth() -> Bool
}
