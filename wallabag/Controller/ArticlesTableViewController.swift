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
import WallabagKit
import WallabagCommon

final class ArticlesTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    let analytics = AnalyticsManager()
    let setting = WallabagSetting()
    var wallabagSync: WallabagSyncing!

    lazy var realm: Realm = {
        do {
            return try Realm()
        } catch {
            fatalError("realm error")
        }
    }()
    var results: Results<Entry>?
    var notificationToken: NotificationToken?
    var searchTimer: Timer?
    var mode: RetrieveMode = .allArticles {
        didSet {
            filteringList()
        }
    }

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
        mode = RetrieveMode(rawValue: segue.identifier!)!
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
            Log("Back from activity")

            guard let entry = realm.object(ofType: Entry.self, forPrimaryKey: selectedEntryId) else {
                return
            }
            performSegue(withIdentifier: "readArticle", sender: entry)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wallabagSync = WallabagSyncing(kit: WallabagSession.shared.kit!)
        wallabagSync.progress = { currentPage, maxPage in
            DispatchQueue.main.async {[weak self] in
                self?.progressView.progress = Float(currentPage) / Float(maxPage)
            }
            Log("Progress \(currentPage)/\(maxPage)")
        }
        self.mode = RetrieveMode(rawValue: setting.get(for: .defaultMode)) ?? .allArticles

        analytics.sendScreenViewed(.articlesView)
        progressView.isHidden = true


        NotificationCenter.default.addObserver(self, selector: #selector(pasteBoardAction), name: UIApplication.didBecomeActiveNotification, object: nil)

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController

        filteringList()
        reloadUI()

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    @objc func handleRefresh() {
        progressView.isHidden = false
        wallabagSync.sync { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.progressView.isHidden = true
            }
        }
        Log("handle refresh")
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
        deleteAction.backgroundColor = UIColor(named: "DeleteColor")

        let starAction = UITableViewRowAction(style: .default, title: entry.isStarred ? "Unstar".localized : "Star".localized, handler: { _, _ in
            self.tableView.setEditing(false, animated: true)
            self.star(entry)
        })
        starAction.backgroundColor = UIColor(named: "StarColor")

        let readAction = UITableViewRowAction(style: .default, title: entry.isArchived ? "Unread".localized : "Read".localized, handler: { _, _ in
            self.tableView.setEditing(false, animated: true)
            self.read(entry)
        })
        readAction.backgroundColor = UIColor(named: "ReadColor")

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

    func filteringList(_ predicate: NSPredicate? = nil) {
        self.notificationToken?.invalidate()
        self.notificationToken = nil

        if let predicate = predicate {
            self.results = self.realm.objects(Entry.self).filter(predicate)
        } else {
            self.results = self.realm.objects(Entry.self).filter(self.mode.predicate())
        }

        self.results = self.results?.sorted(byKeyPath: "id", ascending: false)

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
        WallabagSession.shared.update(entry)
    }

    private func star(_ entry: Entry) {
        try! realm.write {
            entry.isStarred = !entry.isStarred
        }
        WallabagSession.shared.update(entry)
    }

    private func delete(_ entry: Entry) {
        WallabagSession.shared.delete(entry)
    }

    private func addArticle() {
        let alertController = UIAlertController(title: "Add link".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Url".localized
        })
        alertController.addAction(UIAlertAction(title: "Add".localized, style: .default, handler: { _ in
            if let textfield = alertController.textFields?.first?.text,
                let url = URL(string: textfield) {
                WallabagSession.shared.add(url)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

    private func reloadUI() {
        title = mode.humainReadable().localized
    }
}
