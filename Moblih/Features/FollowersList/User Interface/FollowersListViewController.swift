//
//  FollowersListViewController.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class FollowersListViewController: UIViewController, Loadable {
    
    // MARK: - Property
    
    weak var delegate: FollowersListViewDelegate?
    
    var presenter: FollowersListPresenterInput!
    
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.dataSource = self
        }
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "FollowersListTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowersListTableViewCell")
        presenter.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource

extension FollowersListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersListTableViewCell", for: indexPath) as? FollowersListTableViewCell else { return UITableViewCell() }
        
        let viewModel = presenter.viewModelAtIndexPath(indexPath)
        
        cell.avatar.image = viewModel.image
        cell.loginLabel.text = viewModel.login
        cell.NameLabel.text = viewModel.name
        cell.CompanyLabel.text = viewModel.company
        
        return cell
    }
    
    private func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - FollowersListPresenterOutput

extension FollowersListViewController: FollowersListPresenterOutput {
    func startLoader() {
        startLoading()
    }
    
    func stopLoader() {
        stopLoading()
    }
    
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }
    
    func reloadData() {
        tableview.reloadData()
    }
}
