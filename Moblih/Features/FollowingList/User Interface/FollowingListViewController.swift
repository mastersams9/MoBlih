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
    
    var addFollowerModuleFactory: AddFollowerModuleFactoryProtocol!
    var deleteFollowerModuleFactory: DeleteFollowerModuleFactoryProtocol!
    private var deleteFollowerView: UIView?
    var presenter: FollowingListPresenterInput!
    
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.dataSource = self
            tableview.delegate = self
        }
    }
    
    private var refresherControl: UIRefreshControl?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refresherControl = UIRefreshControl()
        refresherControl.attributedTitle = presenter.refresherAttributedTitle()
        refresherControl.addTarget(self, action: #selector(refresherControlDidTriggerRefresh), for: .valueChanged)
        tableview.register(UINib(nibName: "FollowingListTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowingListTableViewCell")
        tableview.addSubview(refresherControl)
        self.refresherControl = refresherControl
        presenter.viewDidLoad()
    }
    
    @objc private func refresherControlDidTriggerRefresh() {
        presenter.refresherControlDidTriggerRefresh()
    }
}

// MARK: - UITableViewDelegate

extension FollowingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return presenter.titleForDeleteConfirmationButtonForRowAt(indexPath)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.tableViewCommit(editingStyle, forRowAt: indexPath)
    }
}

// MARK: - FollowersListPresenterOutput

extension FollowingListViewController: FollowingListPresenterOutput {
    func displayViewCategories(_ categories: [FollowingListCategoryView]) {
        categories.forEach {
            switch $0 {
            case .addButtonItem:
                if let addFollowerView = addFollowerModuleFactory.makeView(parentViewController: self) {
                    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addFollowerView)]
                }
            }
        }
    }
    
    func startLoader() {
        startLoading()
    }
    
    func stopLoader() {
        stopLoading()
        refresherControl?.endRefreshing()
    }
    
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }
    
    func reloadData() {
        tableview.reloadData()
    }
    
    func commitDelete() {
        if let view = deleteFollowerModuleFactory.makeView() {
            deleteFollowerView = view
            self.view.addSubview(view)
            view.constraintToView(self.view)
            view.viewDidLoad()
        }
    }
    
    func deleteRowsAtIndexPaths(_ indexPaths: [IndexPath],
                                with animation: UITableView.RowAnimation) {
        tableview.deleteRows(at: indexPaths,
                             with: animation)
    }
}


// MARK: - AddFollowerViewDelegate

extension FollowingListViewController: AddFollowerViewDelegate {
    
    func addFollowerViewIsRequesting() {
        startLoading()
    }
    
    func addFollowerViewDidFinishWithSuccess() {
        stopLoading()
        presenter.addFollowerViewDidFinishWithSuccess()
    }
    
    func addFollowerViewDidTriggeredServerError(message: String) {
        stopLoading()
        presentAlertPopupWithTitle(message: message, confirmationTitle: "OK")
    }
    
    func addFollowerViewDidTriggeredNetworkError(message: String) {
        stopLoading()
        presentAlertPopupWithTitle(message: message, confirmationTitle: "OK")
    }
    
    func addFollowerViewDidTriggeredBadUserError(message: String) {
        stopLoading()
        presentAlertPopupWithTitle(message: message, confirmationTitle: "OK")
    }
}

// MARK: - DeleteFollowerViewDelegate

extension FollowingListViewController: DeleteFollowerViewDelegate {
    
    func deleteFollowerViewDidFinishWithSuccess() {
        deleteFollowerView?.removeFromSuperview()
        presenter.deleteFollowerViewDidFinishWithSuccess()
    }
    
    func deleteFollowerViewDidTriggerServerError(message: String) {
        deleteFollowerView?.removeFromSuperview()
        presentAlertPopupWithTitle(message: message, confirmationTitle: "OK")
    }
    
    func deleteFollowerViewDidTriggerNetworkError(message: String) {
        deleteFollowerView?.removeFromSuperview()
        presentAlertPopupWithTitle(message: message, confirmationTitle: "OK")
    }
}
