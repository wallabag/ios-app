//
//  WallabagUserDefaults.swift
//  wallabag
//
//  Created by Marinel Maxime on 20/07/2019.
//

import Foundation

struct WallabagUserDefaults {
    @UserDefault("host", defaultValue: "")
    static var host: String
    
    @UserDefault("clientId", defaultValue: "")
    static var clientId: String
    
    @UserDefault("clientSecret", defaultValue: "")
    static var clientSecret: String
    
    @UserDefault("username", defaultValue: "")
    static var login: String
    
    @Password
    static var password: String
    
    @UserDefault("registred", defaultValue: false)
    static var registred: Bool
}
