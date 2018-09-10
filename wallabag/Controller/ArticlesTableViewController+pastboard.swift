//
//  ArticlesTableViewController+pastboard.swift
//  wallabag
//
//  Created by maxime marinel on 03/09/2018.
//

import Foundation
import WallabagCommon

extension ArticlesTableViewController {
    @objc func pasteBoardAction() {
        guard let pasteBoardUrl = UIPasteboard.general.url,
            pasteBoardUrl.absoluteString != setting.get(for: .previousPasteBoardUrl) else {
                return
        }
        setting.set(pasteBoardUrl.absoluteString, for: .previousPasteBoardUrl)
    
        let alertController = UIAlertController(title: "PasteBoard", message: pasteBoardUrl.absoluteString, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            //self.entryController.add(url: pasteBoardUrl)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alertController, animated: true)
    }
}
