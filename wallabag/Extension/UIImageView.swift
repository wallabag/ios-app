//
//  UIImageView.swift
//  wallabag
//
//  Created by maxime marinel on 08/08/2018.
//

import Foundation
import UIKit

extension UIImageView {
    func display(entry: Entry, withShadow: Bool = false) {
        image = #imageLiteral(resourceName: "logo")
        guard let previewPicture = entry.previewPicture,
            let pictureURL = URL(string: previewPicture)
        else {
            return
        }

        af_setImage(withURL: pictureURL) { [weak self] newImage in
            if newImage.error == nil, withShadow {
                guard let view = self else { return }
                view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
                view.layer.shadowColor = UIColor.black.cgColor
                view.layer.shadowOpacity = 0.5
                view.layer.shadowOffset = CGSize(width: 0, height: 0)
                view.layer.shadowRadius = 5
                view.layer.masksToBounds = false
            }
        }
    }
}
