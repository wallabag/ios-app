//
//  ArticleTagViewController.swift
//  wallabag
//
//  Created by maxime marinel on 12/05/2019.
//

import RealmSwift
import UIKit

class ArticleTagViewController: UIViewController {
    weak var entry: Entry!
    var realm: Realm!
    var wallabagSession: WallabagSession!
    var results: Results<Tag>?
    var notificationToken: NotificationToken?

    @IBOutlet var tableView: UITableView!

    @IBAction func addTag(_: Any) {
        let alertController = UIAlertController(title: "Add tag".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { _ in })
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        alertController.addAction(UIAlertAction(title: "Add".localized, style: .default) { _ in
            if let textfield = alertController.textFields?.first?.text {
                self.wallabagSession.add(tag: textfield, for: self.entry)
            }
        })
        present(alertController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10

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
}

extension ArticleTagViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagIdentifier", for: indexPath)
        cell.accessoryType = .none

        guard let tag = results?[indexPath.row] else { return cell }

        cell.textLabel?.text = tag.label

        entry.tags.forEach {
            if $0.id == tag.id {
                cell.accessoryType = .checkmark
            }
        }

        return cell
    }
}

extension ArticleTagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let tag = results?[indexPath.row], let cell = tableView.cellForRow(at: indexPath) else { return }

        if entry.tags.contains(tag) {
            wallabagSession.delete(tag: tag, for: entry)
            cell.accessoryType = .none
        } else {
            wallabagSession.add(tag: tag.label!, for: entry)
            cell.accessoryType = .checkmark
        }
    }
}
