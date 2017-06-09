//
//  ArticlesTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 20/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import UserNotifications
import WallabagKit
import CoreData
import CoreSpotlight

final class ArticlesTableViewController: UITableViewController {

    let sync = ArticleSync()
    let searchController = UISearchController(searchResultsController: nil)

    var page: Int = 2
    var refreshing: Bool = false
    var entries: [Entry] = []
    var mode: Setting.RetrieveMode = Setting.getDefaultMode()

    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var add: UIBarButtonItem!

    @IBAction func disconnect(segue: UIStoryboardSegue) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.resetApplication()
        appDelegate.window?.rootViewController = appDelegate.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "home")
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        updateUi()
    }

    @IBAction func filterList(segue: UIStoryboardSegue) {
        mode = Setting.RetrieveMode(rawValue: segue.identifier!)!
        handleRefresh()
    }

    @IBAction func addLink(_ sender: UIBarButtonItem) {
        addArticle(self)
    }

    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if CSSearchableItemActionType == activity.activityType {
            guard let userInfo = activity.userInfo,
                let selectedEntry = userInfo[CSSearchableItemActivityIdentifier] as? String,
                let selectedEntryId = Int(selectedEntry.components(separatedBy: ".").last!) else {
                    return
            }

            let fetchRequest = Entry.fetchEntryRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", selectedEntryId as NSNumber)
            let results = (CoreData.fetch(fetchRequest) as? [Entry]) ?? []
            log.debug("Back from activity")

            performSegue(withIdentifier: "readArticle", sender: results.first)
        }
    }

    private func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        if refreshControl?.isRefreshing ?? false {
            refreshControl?.endRefreshing()
        }
    }

    private func updateUi() {
        log.debug("Update ui")
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.scrollTop)))
        titleLabel.text = mode.humainReadable()
        titleLabel.textColor = Setting.getTheme().color
        navigationItem.titleView = titleLabel

        navigationController?.navigationBar.setBackgroundImage(Setting.getTheme().navigationBarBackground, for: .default)
        menu.tintColor = Setting.getTheme().tintColor
        add.tintColor = Setting.getTheme().tintColor

        tableView.backgroundColor = Setting.getTheme().backgroundColor
        for row in 0 ... tableView.numberOfRows(inSection: 0) {
            tableView.cellForRow(at: IndexPath(row: row, section: 0))?.backgroundColor = Setting.getTheme().backgroundColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: CoreData.context
        )

        handleRefresh()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    func managedObjectContextObjectsDidChange(notification: NSNotification) {
        if  notification.userInfo == nil { return }
        log.debug("managedObjectContextObjectsDidChange")
        handleRefresh()
    }

    func scrollTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }

        cell.present(entries[indexPath.row])

        return cell
    }

    func handleRefresh() {
        updateUi()
        sync.sync()
        log.debug("Handle refresh")
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]

        switch mode {
        case .unarchivedArticles:
            fetchRequest.predicate = NSPredicate(format: "is_archived == 0")
            break
        case .starredArticles:
            fetchRequest.predicate = NSPredicate(format: "is_starred == 1")
            break
        case .archivedArticles:
            fetchRequest.predicate = NSPredicate(format: "is_archived == 1")
        default: break

        }

        entries = (CoreData.fetch(fetchRequest) as? [Entry]) ?? []
        refreshTableView()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let entry = entries[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized, handler: { _, _ in
            self.delete(entry)
        })
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.188235294, alpha: 1)

        let starAction = UITableViewRowAction(style: .default, title: entry.is_starred ? "Unstar".localized : "Star".localized, handler: { _, _ in
            self.tableView.setEditing(false, animated: true)
            self.star(entry)
        })
        starAction.backgroundColor = #colorLiteral(red: 1, green: 0.584313725, blue: 0, alpha: 1)

        let readAction = UITableViewRowAction(style: .default, title: entry.is_archived ? "Unread".localized : "Read".localized, handler: { _, _ in
            self.tableView.setEditing(false, animated: true)
            self.read(entry)
        })
        readAction.backgroundColor = #colorLiteral(red: 0, green: 0.478431373, blue: 1, alpha: 1)

        return [deleteAction, starAction, readAction]
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "readArticle" {
            if let controller = segue.destination as? ArticleViewController {
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
                    self.addArticle(controller)
                }

                if let cell = sender as? UITableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    if let index = indexPath?.row {
                        controller.entry = entries[index]
                    }
                }
                if let entry = sender as? Entry {
                    controller.entry = entry
                }
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func read(_ entry: Entry) {
        entry.is_archived = !entry.is_archived
        entry.updated_at = NSDate()
        CoreData.saveContext()
        WallabagApi.patchArticle(Int(entry.id), withParamaters: ["archive": (entry.is_archived).hashValue]) { _ in

        }
    }

    private func star(_ entry: Entry) {
        entry.is_starred = !entry.is_starred
        entry.updated_at = NSDate()
        CoreData.saveContext()
        WallabagApi.patchArticle(Int(entry.id), withParamaters: ["starred": (entry.is_starred).hashValue]) { _ in
        }
    }

    private func delete(_ entry: Entry) {
        do {
            sync.delete(entry: entry)
            WallabagApi.deleteArticle(Int(entry.id)) {}
            try CoreData.delete(entry)
        } catch {
        }
    }

    private func addArticle(_ fromController: UIViewController) {
        let alertController = UIAlertController(title: "Add link".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Url".localized
        })
        alertController.addAction(UIAlertAction(title: "Add".localized, style: .default, handler: { _ in
            if let textfield = alertController.textFields?.first?.text {
                if let url = URL(string: textfield) {
                    WallabagApi.addArticle(url) { article in
                        self.sync.insert(article)
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))

        fromController.present(alertController, animated: true)
    }
}

extension ArticlesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            handleRefresh()
            return
        }
        log.debug("search: " + searchController.searchBar.text!)
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
        let predicateTitle = NSPredicate(format: "title CONTAINS[cd] %@", searchController.searchBar.text!)
        let predicateContent = NSPredicate(format: "content CONTAINS[cd] %@", searchController.searchBar.text!)
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateContent])
        entries = (CoreData.fetch(fetchRequest) as? [Entry]) ?? []

        tableView.reloadData()
    }
}
