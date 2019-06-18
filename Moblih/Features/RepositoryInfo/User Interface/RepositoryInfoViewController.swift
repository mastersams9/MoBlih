//
//  RepositoryInfoViewController.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class RepositoryInfoViewController: UIViewController, Loadable {

    var presenter: RepositoryInfoPresenterInput!
    private var refresherControl: UIRefreshControl?
    
    @IBOutlet weak var repositoryImageView: UIImageView!
    @IBOutlet weak var repositoryOwnerTextLabel: UILabel!
    @IBOutlet weak var repositoryOwnerLabel: UILabel!
    @IBOutlet weak var repositoryOwnerImageView: UIImageView!
    @IBOutlet weak var repositoryDescriptionTextLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    @IBOutlet weak var repositoryStarsTextLabel: UILabel!
    @IBOutlet weak var repositoryStarsLabel: UILabel!
    @IBOutlet weak var repositoryWatchersTextLabel: UILabel!
    @IBOutlet weak var repositoryWatchersLabel: UILabel!
    @IBOutlet weak var repositoryLastUpdateTextLabel: UILabel!
    @IBOutlet weak var repositoryLastUpdateLabel: UILabel!
    @IBOutlet weak var repositoryDefaultBranchTextLabel: UILabel!
    @IBOutlet weak var repositoryDefaultBranchLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var manageCollaboratorsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        let refresherControl = UIRefreshControl()
        refresherControl.attributedTitle = presenter?.refresherAttributedTitle()
        refresherControl.addTarget(self, action: #selector(refresherControlDidTriggerRefresh), for: .valueChanged)
        self.refresherControl = refresherControl
        self.scrollView.addSubview(refresherControl)
        presenter.viewDidLoad()
    }
    
    @objc private func refresherControlDidTriggerRefresh() {
        presenter.refresherControlDidTriggerRefresh()
    }

    @IBAction func manageCollaboratorsDidTouchUpInside(_ sender: UIButton) {
        presenter.manageCollaboratorsDidTouchUpInside()
    }
}

extension RepositoryInfoViewController: RepositoryInfoPresenterOutput {
    func startLoader() {
        startLoading()
    }
    
    func stopLoader() {
        stopLoading()
        refresherControl?.endRefreshing()
    }
    
    func displayRepositoryInformation(viewModel: RepositoryInfoRepositoryViewModelProtocol) {
        title = viewModel.title
        repositoryImageView.image = viewModel.repositoryPrivacyImage
        repositoryOwnerTextLabel.text = viewModel.ownerText
        repositoryOwnerLabel.text = viewModel.ownerName
        repositoryOwnerImageView.image = viewModel.ownerAvatarImage
        repositoryDescriptionTextLabel.text = viewModel.descriptionText
        repositoryDescriptionLabel.text = viewModel.description
        repositoryStarsTextLabel.text = viewModel.starsCountText
        repositoryStarsLabel.text = viewModel.starsCount
        repositoryWatchersTextLabel.text = viewModel.watchersCountText
        repositoryWatchersLabel.text = viewModel.watchersCount
        repositoryLastUpdateTextLabel.text = viewModel.lastUpdatedText
        repositoryLastUpdateLabel.text = viewModel.lastUpdated
        repositoryDefaultBranchTextLabel.text = viewModel.defaultBranchText
        repositoryDefaultBranchLabel.text = viewModel.defaultBranch
    }
    
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }

    func updateManageCollaboratorsButtonVisibility(_ isVisible: Bool) {
        manageCollaboratorsButton.isHidden = !isVisible
    }
}
