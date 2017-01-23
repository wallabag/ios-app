//
//  ArticleTableViewCell.swift
//  wallabag
//
//  Created by maxime marinel on 25/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class ArticleTableViewCell: ThemedTableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var readingTime: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var readed: UIImageView!
    @IBOutlet weak var starred: UIImageView!

    func present(_ article: Article) {
        setupTheme()

        title.text = article.title
        website.text = article.domainName

        if !article.isArchived {
            title.font = UIFont.boldSystemFont(ofSize: 16.0)
            readed.image = #imageLiteral(resourceName: "unreaded")
        } else {
            title.font = UIFont.systemFont(ofSize: 16.0)
            readed.image = #imageLiteral(resourceName: "readed")
        }

        starred.image = article.isStarred ? #imageLiteral(resourceName: "starred") : #imageLiteral(resourceName: "unstarred")

        if let picture = article.previewPicture {
            previewImage.image(fromString: picture)
        } else {
            previewImage.image = #imageLiteral(resourceName: "logo-icon-black-no-bg")
        }

        readingTime.text = "Reading time \(article.readingTime.readingTime)"
    }

    override func setupTheme() {
        super.setupTheme()
        title?.textColor = Setting.getTheme().color
        website?.textColor = Setting.getTheme().color
        readingTime?.textColor = Setting.getTheme().color
    }
}
