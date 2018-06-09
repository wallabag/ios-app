//
//  WallabagKitCollectionResponse.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

enum WallabagKitCollectionResponse<T: Decodable> {
    case success(WallabagKitCollection<T>)
    case error(Error)
}
