//
//  EntryExtension.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import CoreSpotlight
import Foundation
import MobileCoreServices
import WallabagKit

extension Entry {
    var spotlightIdentifier: String {
        return "\(Bundle.main.bundleIdentifier!).spotlight.\(Int(id))"
    }

    var searchableItemAttributeSet: CSSearchableItemAttributeSet {
        let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        searchableItemAttributeSet.title = title
        searchableItemAttributeSet.contentDescription = content?.withoutHTML

        return searchableItemAttributeSet
    }

    func hydrate(from article: WallabagKitEntry) {
        if 0 == id {
            setValue(article.id, forKey: "id")
        }
        title = article.title
        content = article.content
        createdAt = Date.fromISOString(article.createdAt)
        updatedAt = Date.fromISOString(article.updatedAt)
        domainName = article.domainName
        isArchived = article.isArchived == 1
        isStarred = article.isStarred == 1
        previewPicture = article.previewPicture
        url = article.url
        readingTime = article.readingTime ?? 0
        article.tags?.forEach {
            let tag = Tag()
            tag.id = $0.id!
            tag.label = $0.label ?? ""
            tag.slug = $0.slug ?? ""
            tags.append(tag)
        }
    }
}
