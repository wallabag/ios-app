//
//  ArticlesTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 20/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import CoreSpotlight
import RealmSwift

final class ArticlesTableViewController: UITableViewController {

    let articleSync: ArticleSync = ArticleSync.sharedInstance
    let searchController = UISearchController(searchResultsController: nil)

    lazy var realm: Realm = {
        do {
            return try Realm()
        } catch {
            fatalError("realm error")
        }
    }()
    var results: Results<Entry>?
    var notificationToken: NotificationToken?

    var mode: Setting.RetrieveMode = Setting.getDefaultMode()

    @IBOutlet var progressView: UIProgressView!

    @IBAction func disconnect(segue: UIStoryboardSegue) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let alert = UIAlertController(title: "Disconnect".localized, message: "Are you sure?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Disconnect".localized, style: .destructive) { _ in
            appDelegate.resetApplication()
            appDelegate.window?.rootViewController = appDelegate.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "home")

        })
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            appDelegate.window?.rootViewController?.present(alert, animated: false)
        })
    }

    @IBAction func filterList(segue: UIStoryboardSegue) {
        mode = Setting.RetrieveMode(rawValue: segue.identifier!)!
        filteringList()
    }

    @IBAction func addLink(_ sender: UIBarButtonItem) {
        addArticle()
    }

    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if CSSearchableItemActionType == activity.activityType {
            guard let userInfo = activity.userInfo,
                let selectedEntry = userInfo[CSSearchableItemActivityIdentifier] as? String,
                let selectedEntryId = Int(selectedEntry.components(separatedBy: ".").last!) else {
                    return
            }
            NSLog("Back from activity")

            guard let entry = realm.object(ofType: Entry.self, forPrimaryKey: selectedEntryId) else {
                return
            }
            performSegue(withIdentifier: "readArticle", sender: entry)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
        articleSync.initSession()

        NotificationCenter.default.addObserver(self, selector: #selector(pasteBoardAction), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.searchController = searchController
//        } else {
//            tableView.tableHeaderView = searchController.searchBar
//        }

        filteringList()
        reloadUI()

        DispatchQueue.global(qos: .background).async {
            self.handleRefresh()
        }
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        reloadUI()
    }

    private func authError() {
        Setting.set(wallabagConfigured: false)
        let alert = UIAlertController(title: "Error".localized, message: "Authentication error".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive) { _ in
            let homeController = self.storyboard?.instantiateInitialViewController()
            self.present(homeController!, animated: false)
        })
        present(alert, animated: true)
    }

    @objc func pasteBoardAction() {
        let previousPasteBoardUrl = UserDefaults.standard.string(forKey: "previousPasteBoardUrl")
        guard let pasteBoardUrl = UIPasteboard.general.url,
            pasteBoardUrl.absoluteString != previousPasteBoardUrl else {
                return
        }
        UserDefaults.standard.set(pasteBoardUrl.absoluteString, forKey: "previousPasteBoardUrl")
        let alertController = UIAlertController(title: "PasteBoard", message: pasteBoardUrl.absoluteString, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            self.articleSync.add(url: pasteBoardUrl)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alertController, animated: true)
    }

    @objc func handleRefresh() {
        DispatchQueue.main.async {
            if self.refreshControl?.isRefreshing ?? false {
                self.refreshControl?.endRefreshing()
            }
        }

        articleSync.sync { state in
            switch state {
            case .running:
                DispatchQueue.main.async {
                    self.progressView.isHidden = false
                    self.progressView.progress = Float(self.articleSync.pageCompleted) / Float(self.articleSync.maxPage)
                }
            case .finished:
                DispatchQueue.main.async {
                    self.progressView.isHidden = true
                }
            case .error:
                self.authError()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        cell.present(results![indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let entry = results![indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized, handler: { _, _ in
            self.delete(entry)
        })
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.188235294, alpha: 1)

        let starAction = UITableViewRowAction(style: .default, title: entry.isStarred ? "Unstar".localized : "Star".localized, handler: { _, _ in
            self.tableView.setEditing(false, animated: true)
            self.star(entry)
        })
        starAction.backgroundColor = #colorLiteral(red: 1, green: 0.584313725, blue: 0, alpha: 1)

        let readAction = UITableViewRowAction(style: .default, title: entry.isArchived ? "Unread".localized : "Read".localized, handler: { _, _ in
            self.tableView.setEditing(false, animated: true)
            self.read(entry)
        })
        readAction.backgroundColor = #colorLiteral(red: 0, green: 0.478431373, blue: 1, alpha: 1)

        return [deleteAction, starAction, readAction]
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "readArticle",
            let controller = segue.destination as? ArticleViewController {
            controller.readHandler = { entry in
                self.read(entry)
            }
            controller.starHandler = { entry in
                self.star(entry)
            }
            controller.deleteHandler = { entry in
                self.delete(entry)
            }
            controller.addHandler = {
                self.addArticle()
            }
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                controller.entry = results![indexPath.row]
            }
            if let entry = sender as? Entry {
                controller.entry = entry
            }
        }
    }

    private func filteringList(_ predicate: NSPredicate? = nil) {
        self.notificationToken?.invalidate()
        self.notificationToken = nil

        if let predicate = predicate {
            self.results = self.realm.objects(Entry.self).filter(predicate)
        } else {
            self.results = self.realm.objects(Entry.self).filter(self.mode.predicate())
        }

        self.results = self.results?.sorted(byKeyPath: "createdAt", ascending: false)

        self.notificationToken = self.results?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                fatalError("\(err)")
                break
            }
        }
        self.reloadUI()
        self.tableView.reloadData()
    }

    private func read(_ entry: Entry) {
        try! realm.write {
            entry.isArchived = !entry.isArchived
        }
        articleSync.update(entry: entry)
    }

    private func star(_ entry: Entry) {
        try! realm.write {
            entry.isStarred = !entry.isStarred
        }
        articleSync.update(entry: entry)
    }

    private func delete(_ entry: Entry) {
        articleSync.delete(entry: entry)
    }

    private func addArticle() {
        let alertController = UIAlertController(title: "Add link".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Url".localized
        })
        alertController.addAction(UIAlertAction(title: "Add".localized, style: .default, handler: { _ in
            if let textfield = alertController.textFields?.first?.text {
                if let url = URL(string: textfield) {
                    self.articleSync.add(url: url)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

    private func reloadUI() {
        title = mode.humainReadable().localized
    }
}

extension ArticlesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSLog("search: " + searchController.searchBar.text!)
        let textSearch = searchController.searchBar.text!
        if ("" == textSearch) {
            return
        }
        let predicateTitle = NSPredicate(format: "title CONTAINS[cd] %@", textSearch)
        let predicateContent = NSPredicate(format: "content CONTAINS[cd] %@", textSearch)
        let predicateCompound =  NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateContent])

        filteringList(predicateCompound)
        //self.notificationToken?.invalidate()


        //self.results = try! self.realm.objects(Entry.self).filter(predicateCompound).sorted(byKeyPath: "createdAt", ascending: false)
       //self.tableView.reloadData()
    }
}
