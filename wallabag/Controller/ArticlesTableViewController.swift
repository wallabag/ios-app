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
    var articlesManager: ArticleManager = ArticleManager()

    fileprivate func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.refreshControl?.endRefreshing()
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

    @IBAction func unarchivedArticles(segue: UIStoryboardSegue) {
        WallabagApi.mode = .unarchivedArticles
        handleRefresh()
    }

    @IBAction func allArticles(segue: UIStoryboardSegue) {
        WallabagApi.mode = .allArticles
        handleRefresh()
    }

    @IBAction func archivedArticles(segue: UIStoryboardSegue) {
        WallabagApi.mode = .archivedArticles
        handleRefresh()
    }

    @IBAction func starredArticles(segue: UIStoryboardSegue) {
        WallabagApi.mode = .starredArticles
        handleRefresh()
    }

    @IBAction func addLink(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add link", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Url"
        })
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { alert in
            if let textfield = alertController.textFields?.first?.text {
                if let url = URL(string: textfield) {
                    WallabagApi.addArticle(url) { article in
                        self.articlesManager.insert(article: article)
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true)
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
        return articlesManager.getArticles().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as? ArticleTableViewCell {
            cell.present(articlesManager.getArticles()[indexPath.item])
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func handleRefresh() {
        updateUi()
        WallabagApi.retrieveArticle(page: 1) { articles in
            self.articlesManager.setArticles(articles: articles)
            self.page = 2
            self.refreshTableView()
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView && ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 100) && !refreshing {
            refreshing = true
            WallabagApi.retrieveArticle(page: page) { articles in
                self.page += 1
                self.refreshing = false
                self.articlesManager.addArticles(articles: articles)
                self.refreshTableView()
            }
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = articlesManager.getArticles()[indexPath.row]
            delete(article, indexPath: indexPath)
        }
    }

    func delete(_ article: Article, indexPath: IndexPath) {
        WallabagApi.deleteArticle(article) {
            self.articlesManager.removeArticle(atIndex: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.refreshTableView()
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
                        controller.article = articlesManager.getArticle(atIndex: index)
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
        articlesManager.update(article: article, at: index.row)
        refreshTableView()
    }
}
