//
//  Light.swift
//  wallabag
//
//  Created by maxime marinel on 12/07/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import UIKit

class Light: ThemeProtocol {
    var name: String = "light"
    var color: UIColor = UIColor.init(red: 64.rgb, green: 64.rgb, blue: 64.rgb, alpha: 1)
    var tintColor: UIColor = UIColor.init(red: 64.rgb, green: 64.rgb, blue: 64.rgb, alpha: 1)
    var barStyle: UIBarStyle = .default
    var backgroundColor: UIColor = UIColor.init(red: 246.rgb, green: 239.rgb, blue: 220.rgb, alpha: 1)
    var navigationBarBackground: UIImage? = #imageLiteral(resourceName: "navBackgroundSoft")
    var backgroundSelectedColor: UIColor = UIColor.init(red: 221.rgb, green: 215.rgb, blue: 198.rgb, alpha: 1)
}
