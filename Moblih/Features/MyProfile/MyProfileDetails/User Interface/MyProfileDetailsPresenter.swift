//
//  MyProfileDetailsPresenter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

final class MyProfileDetailsPresenter {

    // MARK: - Property

    weak var output: MyProfileDetailsPresenterOutput?
    private var interactor: MyProfileDetailsInteractorInput

    // MARK: - Lifecycle

    init(interactor: MyProfileDetailsInteractorInput) {
        self.interactor = interactor
    }

    // MARK: - Converting

}

// MARK: - MyProfileDetailsPresenterInput

extension MyProfileDetailsPresenter: MyProfileDetailsPresenterInput {
    func followingButtonDidTouchUp() {
        interactor.prepareFollowing()
    }
    
    func followersButtonDidTouchUp() {
        interactor.prepareFollowers()
    }
    
    
    func viewDidLoad() {
        interactor.retrieve()
    }

    func refresh() {
        interactor.refresh()
    }
}

// MARK: - MyProfileDetailsInteractorOutput

extension MyProfileDetailsPresenter: MyProfileDetailsInteractorOutput {
    func routeToFollowing() {
        output?.delegateFollowingButtonDidTouchUp()
    }
    
    func routeToFollowers() {
        output?.delegateFollowersButtonDidTouchUp()
    }
    

    func notifyLoading() {
        output?.startLoader()
    }

    func notifyServerError() {
        output?.stopLoader()
        output?.delegateServerError("Server Error", message: "Oops! a server error occured while fetching profile information. Please try again later.", confirmationTitle: "OK")
    }

    func notifyNetworkError() {
        output?.stopLoader()
        output?.delegateNetworkError("Network Error", message: "Please check your connectivity.", confirmationTitle: "OK")
    }

    func loadUserProfile(_ userProfile: MyProfileDetailsItemProtocol) {
        var ownerImage = #imageLiteral(resourceName: "myProfile")

        if let ownerImageData = userProfile.ownerAvatarData, let ownerImageOpt = UIImage(data: ownerImageData) {
            ownerImage = ownerImageOpt
        }

        let followers = userProfile.followers
        let followings = userProfile.followings

        let userDataModel = MyProfileDetailsViewModel(image: ownerImage, login: userProfile.login, name: userProfile.name ?? "Empty name" , company: userProfile.company ?? "No company" , numberOfRepositories: String(userProfile.numberOfRepos), followers: "\(followers)", followings: "\(followings)")
        output?.stopLoader()
        output?.displayProfileInformation(userDataModel)
        output?.delegateSuccess()
    }

}

// MARK: - Privates

private struct MyProfileDetailsViewModel: MyProfileDetailsViewModelProtocol {
    var image: UIImage
    var login: String
    var name: String
    var company: String
    var numberOfRepositories: String
    var followers: String
    var followings: String
}
