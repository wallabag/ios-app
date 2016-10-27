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
    @IBOutlet weak var previewImage: UIImageView!

    func present(_ article: Article) {
        title.text = article.title

        if !article.is_archived {
            title.font = UIFont.boldSystemFont(ofSize: 16.0)
        }

        previewImage.image = UIImage()
        if let picture = article.preview_picture {
            previewImage.imageFromUrl(picture)
        }
    }
}
