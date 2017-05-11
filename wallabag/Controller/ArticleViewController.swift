//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import TUSafariActivity
import WallabagKit

final class ArticleViewController: UIViewController {

    weak var delegate: ArticlesTableViewController?
    var index: IndexPath!
    var update: Bool = true
    var entry: Entry! {
        didSet {
            updateUi()
        }
    }

    @IBAction func read(_ sender: Any) {
        entry.is_archived = !entry.is_archived
        entry.updated_at = NSDate()
        CoreData.saveContext()
        WallabagApi.patchArticle(Int(entry.id), withParamaters: ["archive": (entry.is_archived).hashValue]) { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func star(_ sender: Any) {
        entry.is_starred = !entry.is_starred
        entry.updated_at = NSDate()
        CoreData.saveContext()
        WallabagApi.patchArticle(Int(entry.id), withParamaters: ["starred": (entry.is_starred).hashValue]) { _ in
            self.updateUi()
        }
    }

    @IBAction func shareMenu(_ sender: UIBarButtonItem) {
        let activity = TUSafariActivity()
        let shareController = UIActivityViewController(activityItems: [URL(string: entry.url!) as Any], applicationActivities: [activity])
        shareController.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]

        shareController.popoverPresentationController?.barButtonItem = sender

        present(shareController, animated: true)
    }

    @IBAction func deleteArticle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            WallabagApi.deleteArticle(Int(self.entry.id)) {
                self.update = false
                self.delegate?.delete(indexPath: self.index)
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        })
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.popoverPresentationController?.barButtonItem = sender

        present(alert, animated: true)
    }

    @IBOutlet weak var contentWeb: UIWebView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = entry.title
        updateUi()
        loadArticleContent()
        contentWeb.backgroundColor = Setting.getTheme().backgroundColor
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil && update {
            delegate?.handleRefresh()
        }
    }

    private func loadArticleContent() {
        DispatchQueue.main.async { [unowned self] in
            self.contentWeb.loadHTMLString(self.contentForWebView(self.entry), baseURL: Bundle.main.bundleURL)
        }
    }

    func contentForWebView(_ entry: Entry) -> String {
        do {
            let html = try String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)

            let justify = Setting.isJustifyArticle() ? "justify.css" : ""
            let theme = Setting.getTheme()

            return String(format: html, arguments: [justify, theme.rawValue, entry.title!, entry.content!])
        } catch {
            fatalError("Unable to load article view")
        }
    }

    private func updateUi() {
        readButton?.image = entry.is_archived ? #imageLiteral(resourceName: "readed") : #imageLiteral(resourceName: "unreaded")
        starButton?.image = entry.is_starred ? #imageLiteral(resourceName: "starred") : #imageLiteral(resourceName: "unstarred")
    }
}
