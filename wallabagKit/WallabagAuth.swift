//
//  WallabagAuth.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

public enum WallabagAuth {
    case success(WallabagAuthSuccess)
    case error(WallabagAuthError)
    case invalidParameter
    case unexpectedError
}
