//
//  Dark.swift
//  wallabag
//
//  Created by maxime marinel on 12/07/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import UIKit

class Night: ThemeProtocol {
    var name: String = "night"
    var color: UIColor = UIColor(red: 153.rgb, green: 153.rgb, blue: 153.rgb, alpha: 1)
    var tintColor: UIColor = UIColor(red: 153.rgb, green: 153.rgb, blue: 153.rgb, alpha: 1)
    var barStyle: UIBarStyle = .black
    var backgroundColor: UIColor = UIColor(red: 34.rgb, green: 34.rgb, blue: 34.rgb, alpha: 1)
    var navigationBarBackground: UIImage? = #imageLiteral(resourceName: "navBackgroundNight")
    var backgroundSelectedColor: UIColor = UIColor(red: 56.rgb, green: 56.rgb, blue: 56.rgb, alpha: 1)
}
