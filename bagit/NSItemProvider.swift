//
//  NSItemProvider.swift
//  bagit
//
//  Created by Marinel Maxime on 09/02/2020.
//

import Foundation
import MobileCoreServices

extension NSItemProvider {
    var isText: Bool {
        hasItemConformingToTypeIdentifier(kUTTypePlainText as String)
    }

    var isURL: Bool {
        hasItemConformingToTypeIdentifier(kUTTypeURL as String)
    }

    func getUrl(completion: @escaping (String) -> Void) {
        loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (url, _) -> Void in
            completion((url as? NSURL)!.absoluteString!)
        }
    }

    // swiftlint:disable force_cast
    func getText(completion: @escaping (String) -> Void) {
        loadItem(forTypeIdentifier: kUTTypePlainText as String, options: nil) { (text, _) -> Void in
            completion(text as! String)
        }
    }
}
