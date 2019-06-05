//
//  FollowingListViewController.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class FollowingListViewController: UIViewController, Loadable {
    
    // MARK: - Property
    
    weak var delegate: FollowingListViewDelegate?
    
    var presenter: FollowingListPresenterInput!
    
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.dataSource = self
        }
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "FollowingListTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowingListTableViewCell")
        presenter.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource

extension FollowingListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingListTableViewCell", for: indexPath) as? FollowingListTableViewCell else { return UITableViewCell() }
        
        let viewModel = presenter.viewModelAtIndexPath(indexPath)
        
        cell.AvatarImageView.image = viewModel.image
        cell.LoginLabel.text = viewModel.login
        cell.NameLabel.text = viewModel.name
        cell.CompanyLabel.text = viewModel.company
        
        return cell
    }
    
    private func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - FollowersListPresenterOutput

extension FollowingListViewController: FollowingListPresenterOutput {
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
