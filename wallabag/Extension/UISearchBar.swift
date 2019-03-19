//
//  UISearchBar.swift
//  wallabag
//
//  Created by maxime marinel on 19/03/2019.
//

import UIKit

extension UISearchBar {
    var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
}
