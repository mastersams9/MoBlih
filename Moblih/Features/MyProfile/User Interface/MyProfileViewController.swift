//
//  MyProfileViewController.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class MyProfileViewController: UITableViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellName = "MyRepositoryTableViewCell"
    }

    // MARK: - Property

    var presenter: MyProfilePresenterInput!
    var logoutModuleFactory: LogoutModuleFactoryProtocol!
    var myProfileDetailsModuleFactory: MyProfileDetailsModuleFactoryProtocol?

    private var refresherControl: UIRefreshControl?

    private var myProfileDetailsView: MyProfileDetailsView?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.cellName)
        let refresherControl = UIRefreshControl()
        refresherControl.attributedTitle = presenter.refresherAttributedTitle()
        refresherControl.addTarget(self, action: #selector(refresherControlDidTriggerRefresh), for: .valueChanged)
        tableView.addSubview(refresherControl)
        self.refresherControl = refresherControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.viewWillAppear()
    }

    @objc private func refresherControlDidTriggerRefresh() {
        myProfileDetailsView?.refresh()
        presenter.refresherControlDidTriggerRefresh()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.titleForHeaderInSection(section)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath) as? MyRepositoryTableViewCell else { return UITableViewCell() }
        
        let viewModel = presenter.viewModelAtIndexPath(indexPath)
        
        cell.titleLabel.text = viewModel.title
        cell.descriptionLabel.text = viewModel.description
        cell.repositoryImageView.image = viewModel.image
        cell.ownerNameLabel.text = viewModel.ownerName
        cell.ownerImageView.image = viewModel.ownerImage
        cell.lastUpdatedLabel.text = viewModel.lastUpdated
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


// MARK: - MyProfilePresenterOutput

extension MyProfileViewController: MyProfilePresenterOutput {
    func reloadData() {
        tableView.reloadData()
    }
    
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }
    
    func startLoader() {
        tableView.startLoading(on: Constants.cellName)
    }

    func stopLoader() {
        tableView.stopLoading()
        refresherControl?.endRefreshing()
    }

    func displayViewCategories(_ categories: [CategoryView]) {
        categories.forEach {
            switch $0 {
            case .logoutButtonItem:
                if let logoutView = logoutModuleFactory.makeView() {
                    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: logoutView)]
                }
            case .myProfileDetails:
                myProfileDetailsView = myProfileDetailsModuleFactory?.makeView()
                myProfileDetailsView?.viewDidLoad()
                tableView.tableHeaderView = myProfileDetailsView
            }
        }
    }
}

// MARK: - MyProfilePresenterOutput

extension MyProfileViewController: LogoutViewDelegate {

    func logoutViewIsRequesting() {
        presenter.logoutViewIsRequesting()
    }

    func logoutViewDidFinish() {
        presenter.logoutViewDidFinish()
    }
}

// MARK: - MyProfileDetailsViewDelegate

extension MyProfileViewController: MyProfileDetailsViewDelegate {
    func myProfileDetailsViewFollowersButtonDidTouchUp() {
        presenter.myProfileDetailsFollowersButtonDidTouchUp()
    }
    
    func myProfileDetailsViewFollowingButtonDidTouchUp() {
        presenter.myProfileDetailsFollowingButtonDidTouchUp()
    }

    func myProfileDetailsViewDidTriggerServerError(_ title: String, message: String, confirmationTitle: String) {
        displayAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }

    func myProfileDetailsViewDidTriggerNetworkError(_ title: String, message: String, confirmationTitle: String) {
        presenter.myProfileDetailsViewDidTriggerNetworkError()
    }
}
