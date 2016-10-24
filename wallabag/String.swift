//
//  String.swift
//  wallabag
//
//  Created by maxime marinel on 22/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var date: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

            return dateFormatter.date(from: self)
        }
    }

    // @todo optimize time
    var attributedHTML: NSAttributedString {
        get {
            return try! NSAttributedString(data: self.data(using: .unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        }
    }

}
