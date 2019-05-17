//
//  TagsTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 10/05/2019.
//

import RealmSwift
import UIKit
import WallabagCommon

class TagsTableViewController: UITableViewController {
    var analytics: AnalyticsManager!
    var setting: WallabagSetting!
    var realm: Realm!
    var results: Results<Tag>?
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        notificationToken?.invalidate()
        notificationToken = nil

        results = realm.objects(Tag.self).sorted(byKeyPath: "label")

        notificationToken = results?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case let .error(err):
                fatalError("\(err)")
            }
        }
        tableView.reloadData()
    }

    override func viewWillDisappear(_: Bool) {
        notificationToken = nil
    }

    // MARK: - Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return results?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagIdentifier", for: indexPath)

        guard let tag = results?[indexPath.row] else { return cell }

        cell.textLabel?.text = "\(tag.label!) (\(tag.entries.count))"

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell,
            let controller = segue.destination as? ArticlesTableViewController,
            let indexPath = tableView.indexPath(for: cell) else { return }

        controller.filteringList(NSPredicate(format: "ANY tags.id == \(results![indexPath.row].id)"))
    }
}
