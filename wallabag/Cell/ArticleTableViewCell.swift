//
//  ArticleTableViewCell.swift
//  wallabag
//
//  Created by maxime marinel on 25/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

final class ArticleTableViewCell: ThemedTableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var readingTime: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var readed: UIImageView!
    @IBOutlet weak var starred: UIImageView!

    func present(_ entry: Entry) {
        setupTheme()

        title.text = entry.title
        website.text = entry.domainName

        if !entry.isArchived {
            title.font = UIFont.boldSystemFont(ofSize: 16.0)
            readed.image = #imageLiteral(resourceName: "unreaded")
        } else {
            title.font = UIFont.systemFont(ofSize: 16.0)
            readed.image = #imageLiteral(resourceName: "readed")
        }

        starred.image = entry.isStarred ? #imageLiteral(resourceName: "starred") : #imageLiteral(resourceName: "unstarred")

        readingTime.text = String(format: "Reading time %@".localized, arguments: [Int(entry.readingTime).readingTime])

        previewImage.display(entry: entry)
    }

    override func setupTheme() {
        super.setupTheme()
        title?.textColor = themeManager.getColor()
        website?.textColor = themeManager.getColor()
        readingTime?.textColor = themeManager.getColor()
        readed?.tintColor = themeManager.getTintColor()
        starred?.tintColor = themeManager.getTintColor()
    }
}
