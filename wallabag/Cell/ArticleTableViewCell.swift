//
//  ArticleTableViewCell.swift
//  wallabag
//
//  Created by maxime marinel on 25/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagKit
import AlamofireImage

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
        readingTime.text = "Reading time \(article.readingTime.readingTime)"

        guard let previewPicture = article.previewPicture,
            let pictureURL = URL(string: previewPicture) else {
            previewImage.image = #imageLiteral(resourceName: "logo-icon-black-no-bg")
            return
        }

        previewImage.af_setImage(withURL: pictureURL)
    }

    override func setupTheme() {
        super.setupTheme()
        title?.textColor = Setting.getTheme().color
        website?.textColor = Setting.getTheme().color
        readingTime?.textColor = Setting.getTheme().color
        readed?.tintColor = Setting.getTheme().tintColor
        starred?.tintColor = Setting.getTheme().tintColor
    }
}
