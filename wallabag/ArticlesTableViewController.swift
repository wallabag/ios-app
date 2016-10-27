//
//  ArticlesTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 20/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ArticlesTableViewController: UITableViewController {

    var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        handleRefresh()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as? ArticleTableViewCell {

            let article = articles[indexPath.item]

            cell.present(article)

            return cell
        } else {
            return UITableViewCell()
        }
    }

    func handleRefresh() {
        WallabagApi.retrieveArticle { articles in
            self.articles = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        refreshControl?.endRefreshing()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "readArticle" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    if let controller = segue.destination as? ArticleViewController {
                        controller.article = articles[index]
                    }
                }
            }
        }
    }
}
