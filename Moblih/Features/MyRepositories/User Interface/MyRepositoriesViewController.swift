//
//  MyRepositoriesViewController.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class MyRepositoriesViewController: UIViewController, Loadable {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    // MARK: - Property

    var presenter: MyRepositoriesPresenterInput!
    private var refresherControl: UIRefreshControl?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "MyRepositoryTableViewCell")
        
        let refresherControl = UIRefreshControl()
        refresherControl.attributedTitle = presenter.refresherAttributedTitle()
        refresherControl.addTarget(self, action: #selector(refresherControlDidTriggerRefresh), for: .valueChanged)
        tableView.addSubview(refresherControl)
        self.refresherControl = refresherControl
        
        self.presenter?.viewDidLoad()
    }

    @objc private func refresherControlDidTriggerRefresh() {
        presenter.refresherControlDidTriggerRefresh()
    }
    
    // MARK: - IBActions

    @IBAction func addNewRepositoryButtonDidTouchUpInside(_ sender: UIButton) {
        presenter.addNewRepositoryButtonDidTouchUpInside()
    }
}

// MARK: - UITableViewDataSource

extension MyRepositoriesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyRepositoryTableViewCell", for: indexPath) as? MyRepositoryTableViewCell else { return UITableViewCell() }

        let viewModel = presenter.viewModelAtIndexPath(indexPath)

        cell.titleLabel.text = viewModel.title
        cell.descriptionLabel.text = viewModel.description
        cell.repositoryImageView.image = viewModel.image
        cell.ownerNameLabel.text = viewModel.ownerName
        cell.ownerImageView.image = viewModel.ownerImage
        cell.lastUpdatedLabel.text = viewModel.lastUpdated

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - UITableViewDelegate

extension MyRepositoriesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
}


// MARK: - MyRepositoriesPresenterOutput

extension MyRepositoriesViewController: MyRepositoriesPresenterOutput {

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
        tableView.reloadData()
    }
}

// MARK: - AddRepositoryTableViewControllerDelegate

extension MyRepositoriesViewController: AddRepositoryTableViewControllerDelegate {
    func addRepositoryTableViewControllerDidFinish() {
        presenter.addRepositoryTableViewControllerDidFinish()
    }
}
