//
//  TableViewLoader.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit
import ListPlaceholder

class TableViewLoader: UIView {

    var cellName = "TableViewLoaderTableViewCell"

    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.dataSource = self
        }
    }

    func startLoading() {
        tableview.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        tableview.reloadData()
        tableview.showLoader()
    }
}

// MARK: - UITableViewDataSource

extension TableViewLoader: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)

        return cell
    }

    private func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
