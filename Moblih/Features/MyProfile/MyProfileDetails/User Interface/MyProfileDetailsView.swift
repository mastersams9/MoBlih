//
//  MyProfileDetailsView.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class MyProfileDetailsView: UIView, ViewLoadable {

    // MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nbRepositoriesLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!

    // MARK: - Property

    weak var delegate: MyProfileDetailsViewDelegate?

    var presenter: MyProfileDetailsPresenterInput!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - IBActions
    
    @IBAction func FollowersButtonDidTouchUp(_ sender: UIButton) {
        presenter.followersButtonDidTouchUp()
    }
    
    @IBAction func FollowingButtonDidTouchUp(_ sender: Any) {
        presenter.followingButtonDidTouchUp()
    }
    
    // MARK: - Public

    func viewDidLoad() {
        presenter.viewDidLoad()
    }

    func refresh() {
        presenter.refresh()
    }
}

// MARK: - MyProfileDetailsPresenterOutput

extension MyProfileDetailsView: MyProfileDetailsPresenterOutput {
    func delegateFollowingButtonDidTouchUp() {
        delegate?.myProfileDetailsViewFollowingButtonDidTouchUp()
    }
    
    func delegateFollowersButtonDidTouchUp() {
        delegate?.myProfileDetailsViewFollowersButtonDidTouchUp()
    }
    

    func startLoader() {
        startLoading()
    }

    func stopLoader() {
        stopLoading()
    }

    func displayProfileInformation(_ profileInformation: MyProfileDetailsViewModelProtocol) {
        profileImageView.image = profileInformation.image
        userNameLabel.text = profileInformation.login
        lastNameLabel.text = profileInformation.name
        companyLabel.text = profileInformation.company
        nbRepositoriesLabel.text = profileInformation.numberOfRepositories
        self.followersLabel.text = profileInformation.followers
        self.followingLabel.text = profileInformation.followings
    }

    func delegateServerError(_ title: String,
                             message: String,
                             confirmationTitle: String) {
        delegate?.myProfileDetailsViewDidTriggerServerError(title,
                                                            message: message,
                                                            confirmationTitle: confirmationTitle)
    }

    func delegateNetworkError(_ title: String,
                              message: String,
                              confirmationTitle: String) {
        delegate?.myProfileDetailsViewDidTriggerNetworkError(title,
                                                             message: message,
                                                             confirmationTitle: confirmationTitle)
    }

    func delegateSuccess() {
        delegate?.myProfileDetailsViewDidFinishWithSuccess()
    }
}
