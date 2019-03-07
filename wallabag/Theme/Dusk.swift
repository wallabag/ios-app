//
//  Dusk.swift
//  wallabag
//
//  Created by maxime marinel on 12/07/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import UIKit

class Dusk: ThemeProtocol {
    var name: String = "dusk"
    var color: UIColor = UIColor(red: 160.rgb, green: 160.rgb, blue: 160.rgb, alpha: 1)
    var tintColor: UIColor = UIColor(red: 160.rgb, green: 160.rgb, blue: 160.rgb, alpha: 1)
    var barStyle: UIBarStyle = .default
    var backgroundColor: UIColor = UIColor(red: 60.rgb, green: 60.rgb, blue: 60.rgb, alpha: 1)
    var navigationBarBackground: UIImage? = #imageLiteral(resourceName: "navBackgroundDusk")
    var backgroundSelectedColor: UIColor = UIColor(red: 79.rgb, green: 79.rgb, blue: 79.rgb, alpha: 1)
}
