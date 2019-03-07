//
//  ArticleTableViewCell.swift
//  wallabag
//
//  Created by maxime marinel on 25/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import AlamofireImage
import CoreData
import UIKit

final class ArticleTableViewCell: ThemedTableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var website: UILabel!
    @IBOutlet var readingTime: UILabel!
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var readed: UIImageView!
    @IBOutlet var starred: UIImageView!

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
