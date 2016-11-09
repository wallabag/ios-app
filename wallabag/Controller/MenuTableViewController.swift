//
//  MenuTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 31/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    let menu: [[String: String]] = [
        ["All articles": "allArticles"],
        ["Unread articles": "unarchivedArticles"],
        ["Read articles": "archivedArticles"],
        ["Starred articles": "starredArticles"],
        // ["Parameter": "parameter"],,
    ]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuIdentifier", for: indexPath)

        cell.textLabel?.text = menu[indexPath.item].keys.first

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: menu[indexPath.row].values.first!, sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController {
            if (navController.topViewController as? ArticlesTableViewController) != nil {
                WallabagApi.mode = segue.identifier!
            }
        }
    }
}
