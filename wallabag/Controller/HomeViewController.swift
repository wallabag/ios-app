//
//  HomeViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagKit

final class HomeViewController: UIViewController {
    @IBAction func openWallabagIt(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "https://www.wallabag.it/en?pk_campaign=register&pk_kwd=wallabagapp")!)
    }
}
