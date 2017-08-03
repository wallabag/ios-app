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
    var fetchResultsController: NSFetchedResultsController<Entry>!

    let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ArticlesTableViewController.scrollTop)))
        titleLabel.text = Setting.getDefaultMode().humainReadable().localized
        titleLabel.textColor = ThemeManager.manager.getColor()
        return titleLabel
    }()

    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var add: UIBarButtonItem!

    @IBAction func disconnect(segue: UIStoryboardSegue) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.resetApplication()
        appDelegate.window?.rootViewController = appDelegate.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "home")
    }

    @IBAction func filterList(segue: UIStoryboardSegue) {
        do {
            let mode = Setting.RetrieveMode(rawValue: segue.identifier!)!
            fetchResultsController = fetchResultsControllerRequest(mode: mode)
            titleLabel.text = mode.humainReadable().localized
            try fetchResultsController.performFetch()
            tableView.reloadData()
        } catch {

        }
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
            log.debug("Back from activity")
            do {
                let mode = Setting.getDefaultMode()
                fetchResultsController = fetchResultsControllerRequest(mode: mode, textSearch: nil, id: selectedEntryId)
                try fetchResultsController.performFetch()
                tableView.reloadData()
                if let entry = fetchResultsController.fetchedObjects?.first {
                    performSegue(withIdentifier: "readArticle", sender: entry)
                } else {
                    log.error("article not found")
                }

            } catch {

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sync.sync()
        navigationItem.titleView = titleLabel
        do {
            fetchResultsController = fetchResultsControllerRequest(mode: Setting.getDefaultMode())
            try fetchResultsController.performFetch()
        } catch {

        }
        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        reloadUI()
    }

    private func reloadUI() {
        tableView.backgroundColor = ThemeManager.manager.getBackgroundColor()
        navigationController?.navigationBar.setBackgroundImage(ThemeManager.manager.getNavigationBarBackground(), for: .default)
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        reloadUI()
    }

    func handleRefresh() {
        sync.sync()
        if refreshControl?.isRefreshing ?? false {
            refreshControl?.endRefreshing()
        }
    }

    func fetchResultsControllerRequest(mode: Setting.RetrieveMode, textSearch: String? = nil, id: Int? = nil) ->  NSFetchedResultsController<Entry> {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSNumber)
        } else if nil == textSearch || "" == textSearch {
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
        } else {
            let predicateTitle = NSPredicate(format: "title CONTAINS[cd] %@", textSearch!)
            let predicateContent = NSPredicate(format: "content CONTAINS[cd] %@", textSearch!)
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateContent])
        }

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreData.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }

    func scrollTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let entries = fetchResultsController.fetchedObjects else { return 0 }
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }

        cell.present(fetchResultsController.object(at: indexPath))
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let entry = fetchResultsController.object(at: indexPath)
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
                    if let indexPath = tableView.indexPath(for: cell) {
                        controller.entry = fetchResultsController.object(at: indexPath)
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
        sync.update(entry: entry)
    }

    private func star(_ entry: Entry) {
        entry.is_starred = !entry.is_starred
        sync.update(entry: entry)
    }

    private func delete(_ entry: Entry) {
        sync.delete(entry: entry)
    }

    private func addArticle(_ fromController: UIViewController) {
        let alertController = UIAlertController(title: "Add link".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Url".localized
        })
        alertController.addAction(UIAlertAction(title: "Add".localized, style: .default, handler: { _ in
            if let textfield = alertController.textFields?.first?.text {
                if let url = URL(string: textfield) {
                    self.sync.add(url: url)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        fromController.present(alertController, animated: true)
    }
}

extension ArticlesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        log.debug("search: " + searchController.searchBar.text!)
        do {
            fetchResultsController = fetchResultsControllerRequest(mode: Setting.getDefaultMode(), textSearch: searchController.searchBar.text!)
            try fetchResultsController.performFetch()
            tableView.reloadData()
        } catch {

        }
    }
}

extension ArticlesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ArticleTableViewCell {
                cell.present(fetchResultsController.object(at: indexPath))
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default: break
        }
    }
}
