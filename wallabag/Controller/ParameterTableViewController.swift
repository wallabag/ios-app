//
//  ParameterTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class ParameterTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var pickerDataSource = [RetrieveMode.allArticles, RetrieveMode.archivedArticles, RetrieveMode.starredArticles, RetrieveMode.unarchivedArticles]

    @IBOutlet weak var defaultModePicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultModePicker.selectRow(pickerDataSource.index(of: Setting.getDefaultMode())!, inComponent: 0, animated: false)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Setting.setDefaultMode(mode: pickerDataSource[row])
    }
}
