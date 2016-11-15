//
//  ArticlesTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 20/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ArticlesTableViewController: UITableViewController {

    lazy var slideInTransitioningDelegate = SlideInPresentationManager()

    var page: Int = 2
    var refreshing: Bool = false
    var articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            refreshControl?.endRefreshing()

            updateUi()
        }
    }

    fileprivate func updateUi() {
        switch WallabagApi.mode {
        case .allArticles:
            title = "All articles"
            break
        case .archivedArticles:
            title = "Read articles"
            break
        case .starredArticles:
            title = "Starred articles"
            break
        case .unarchivedArticles:
            title = "Unread articles"
            break
        }
    }

    @IBAction func backFromParameter(segue: UIStoryboardSegue) {

    }

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
            cell.present(articles[indexPath.item])
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func handleRefresh() {
        WallabagApi.retrieveArticle(page: 1) { articles in
            self.articles = articles
            self.page = 2
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView && ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 100) && !refreshing {
            refreshing = true
            WallabagApi.retrieveArticle(page: page) { articles in
                self.page += 1
                self.refreshing = false
                self.articles += articles
            }
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = articles[indexPath.row]
            delete(article, indexPath: indexPath)
        }
    }

    func delete(_ article: Article, indexPath: IndexPath) {
        WallabagApi.deleteArticle(article) {
            self.articles.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination

        if segue.identifier == "readArticle" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    if let controller = controller as? ArticleViewController {
                        controller.article = articles[index]
                        controller.index = indexPath
                        controller.delegate = self
                    }
                }
            }
        }

        if segue.identifier == "menu" {
            slideInTransitioningDelegate.direction = .left
            slideInTransitioningDelegate.disableCompactHeight = false
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
        }
    }

    func update(_ article: Article, atIndex index: IndexPath) {
        articles[index.row] = article
    }
}
