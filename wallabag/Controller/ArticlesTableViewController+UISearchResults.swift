//
//  ArticlesTableViewController+UISearchResults.swift
//  wallabag
//
//  Created by maxime marinel on 03/09/2018.
//

import Foundation
import UIKit

extension ArticlesTableViewController: UISearchResultsUpdating {
    @objc func deferSearch(timer: Timer) {
        guard let searchText = timer.userInfo as? String else {
            return
        }

        let predicateTitle = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        let predicateContent = NSPredicate(format: "content CONTAINS[cd] %@", searchText)
        let predicateCompound = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateContent])

        filteringList(predicateCompound)
    }

    func updateSearchResults(for searchController: UISearchController) {
        Log("search: " + searchController.searchBar.text!)
        let searchText = searchController.searchBar.text!
        if "" == searchText {
            return
        }

        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(deferSearch), userInfo: searchText, repeats: false)
    }
}
