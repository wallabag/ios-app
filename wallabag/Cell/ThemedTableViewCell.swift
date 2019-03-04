//
//  ThemedTableViewCell.swift
//  wallabag
//
//  Created by maxime marinel on 18/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class ThemedTableViewCell: UITableViewCell {
    var themeManager: ThemeManager! {
        didSet {
            setupTheme()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _ = NotificationCenter.default.addObserver(forName: Notification.Name.themeUpdated, object: nil, queue: nil) { _ in
            self.setupTheme()
        }
    }

    /**
     Apply the current theme to the cell
     */
    func setupTheme() {
        backgroundColor = themeManager.getBackgroundColor()
        textLabel?.textColor = themeManager.getColor()

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = themeManager.getBackgroundSelectedColor()
    }
}
