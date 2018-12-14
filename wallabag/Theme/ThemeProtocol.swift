//
//  ThemeProtocol.swift
//  wallabag
//
//  Created by maxime marinel on 14/12/2018.
//

import Foundation

protocol ThemeProtocol {
    var name: String {get}
    var color: UIColor {get}
    var tintColor: UIColor {get}
    var barStyle: UIBarStyle {get}
    var backgroundColor: UIColor {get}
    var navigationBarBackground: UIImage? {get}
    var backgroundSelectedColor: UIColor {get}
}
