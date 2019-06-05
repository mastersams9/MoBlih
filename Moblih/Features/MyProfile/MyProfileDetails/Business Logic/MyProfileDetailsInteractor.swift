//
//  MyProfileDetailsInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class MyProfileDetailsInteractor {

    // MARK: - Property

    weak var output: MyProfileDetailsInteractorOutput?

    private var user: MyProfileDetailsItem?
    private let oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol
    private let keychainWrapper: KeychainWrapperInput

    // MARK: - Lifecycle

    init(oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol,
         keychainWrapper: KeychainWrapperInput) {
        self.oauthConfigurationWrapper = oauthConfigurationWrapper
        self.keychainWrapper = keychainWrapper
    }
}

// MARK: - MyProfileDetailsInteractorInput

extension MyProfileDetailsInteractor: MyProfileDetailsInteractorInput {
    func prepareFollowing() {
        output?.routeToFollowing()
    }
    
    func prepareFollowers() {
        output?.routeToFollowers()
    }
    

    func retrieve() {

        output?.notifyLoading()

        guard let accesstoken = try? self.keychainWrapper.findPassword() else {
            output?.notifyServerError()
            return
        }

        self.oauthConfigurationWrapper.retrieveUserInformations(with: accesstoken, success: {[weak self] (userResponse) in
            guard let self = self else { return }
            guard let id = userResponse.id, let login = userResponse.login else {
                self.output?.notifyServerError()
                return
            }

            DispatchQueue.global().async {
                var ownerAvatarData: Data? = nil
                if let urlString = userResponse.avatarURL, let url = URL(string: urlString) {
                    ownerAvatarData = try? Data(contentsOf: url)
                }

                let user = MyProfileDetailsItem(id: id,
                                                  login: login,
                                                  name: userResponse.name,
                                                  company: userResponse.company,
                                                  numberOfPublicRepos: userResponse.numberOfPublicRepos,
                                                  numberOfPrivateRepos: userResponse.numberOfPrivateRepos,
                                                  ownerAvatarData: ownerAvatarData)
                self.user = user
                DispatchQueue.main.async {
                    self.output?.loadUserProfile(user)
                }

            }
        }) { [weak self] (error) in
            switch error {
            case .network:
                self?.output?.notifyNetworkError()
            case .server:
                self?.output?.notifyServerError()
            }
        }
    }

    func refresh() {
        retrieve()
    }
}

// MARK: - Privates

private struct MyProfileDetailsItem: MyProfileDetailsItemProtocol {
    var id: Int
    var login: String
    var name: String?
    var company: String?
    var numberOfPublicRepos: Int?
    var numberOfPrivateRepos: Int?
    var ownerAvatarData: Data?
}

