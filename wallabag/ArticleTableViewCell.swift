//
//  ArticleTableViewCell.swift
//  wallabag
//
//  Created by maxime marinel on 25/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var readingTime: UILabel!
    @IBOutlet weak var previewImage: UIImageView!

    func present(_ article: Article) {
        title.text = article.title
        website.text = article.domain_name

        if !article.is_archived {
            title.font = UIFont.boldSystemFont(ofSize: 16.0)
        }

        previewImage.image = UIImage()
        if let picture = article.preview_picture {
            previewImage.imageFromUrl(picture)
        }

        readingTime.text = "Reading time \(article.reading_time.readingTime)"
    }
}
