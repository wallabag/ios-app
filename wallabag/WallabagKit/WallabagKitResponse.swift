//
//  WallabagKitResponse.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

enum WallabagKitResponse<T: Decodable> {
    case success(T)
    case error(Error)
}
