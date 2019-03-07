//
//  NSNotification.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

public extension NSNotification.Name {
    static let wallabagkitAuthSuccess = NSNotification.Name("wallabagkit.auth.success")
    static let wallabagkitAuthError = NSNotification.Name("wallabagkit.auth.error")
}
