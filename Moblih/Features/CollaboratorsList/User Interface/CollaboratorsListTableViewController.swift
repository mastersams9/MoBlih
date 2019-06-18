//
//  CollaboratorsListTableViewController.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class CollaboratorsListTableViewController: UITableViewController {
    
    // MARK: - Property
    
    var presenter: CollaboratorsListPresenterInput!
    var addCollaboratorModuleFactory: AddCollaboratorModuleFactoryProtocol!
    var removeCollaboratorModuleFactory: RemoveCollaboratorModuleFactoryProtocol!
    private var removeCollaboratorView: UIView?
    private var refresherControl: UIRefreshControl?
    private var addCollaboratorView: UIView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
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
        presenter.refresherControlDidTriggerRefresh()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorsListTableViewCell", for: indexPath) as? CollaboratorsListTableViewCell else { return UITableViewCell() }
        
        let viewModel = presenter.viewModelAtIndexPath(indexPath)
        
        cell.avatar.image = viewModel.image
        cell.loginLabel.text = viewModel.login
        cell.permissionLabel.text = viewModel.permission
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.tableViewCommit(editingStyle, forRowAt: indexPath)
    }
}

// MARK: - CollaboratorsListPresenterOutput

extension CollaboratorsListTableViewController: CollaboratorsListPresenterOutput {
    
    func displayViewCategories(_ categories: [CollaboratorsListCategoryView]) {
        categories.forEach {
            switch $0 {
            case .addButtonItem:
                if let addCollaboratorView = addCollaboratorModuleFactory.makeView(parentViewController: self) {
                    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addCollaboratorView)]
//                    self.addCollaboratorView = addCollaboratorView
                }
            }
        }
    }
    
    func startLoader() {
        tableView.startLoading()
    }
    
    func stopLoader() {
        refresherControl?.endRefreshing()
        tableView.stopLoading()
    }
    
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func commitDelete() {
        if let view = removeCollaboratorModuleFactory.makeView() {
            removeCollaboratorView = view
            self.view.addSubview(view)
            view.constraintToView(self.view)
            view.viewDidLoad()
        }
    }
    
    func deleteRowsAtIndexPaths(_ indexPaths: [IndexPath],
                                with animation: UITableView.RowAnimation) {
        tableView.deleteRows(at: indexPaths,
                             with: animation)
    }
    
}

// MARK: - AddCollaboratorViewDelegate

extension CollaboratorsListTableViewController: AddCollaboratorViewDelegate {
    func addCollaboratorViewIsRequesting() {
        tableView.startLoading()
    }
    
    func addCollaboratorViewDidFinishWithSuccess() {
        tableView.stopLoading()
        presenter.addCollaboratorViewDidFinishWithSuccess()
    }
}

// MARK: - RemoveCollaboratorViewDelegate

extension CollaboratorsListTableViewController: RemoveCollaboratorViewDelegate {
    func removeCollaboratorViewDidFinishWithSuccess() {
        removeCollaboratorView?.removeFromSuperview()
        presenter.deleteFollowerViewDidFinishWithSuccess()
    }
    
    func removeCollaboratorViewDidTriggerServerError(message: String) {
        removeCollaboratorView?.removeFromSuperview()
        presentAlertPopupWithTitle(message: message, confirmationTitle: "OK")
    }
    
    func removeCollaboratorViewDidTriggerNetworkError(message: String) {
        removeCollaboratorView?.removeFromSuperview()
        presentAlertPopupWithTitle(message: message, confirmationTitle: "OK")
    }
}
