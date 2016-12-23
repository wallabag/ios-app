//
//  MenuTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 31/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class MenuTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Setting.getTheme().backgroundColor
    }
}

