//
//  FollowingListInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class FollowingListInteractor {
  // MARK: - Property

    weak var output: FollowingListInteractorOutput?
    private var oauthConfigurationWrapper:OAuthConfigurationWrapper
    private var keychainWrapper: KeychainWrapper
    private var following: [FollowingItemProtocol] = []
  // MARK: - Lifecycle


    
  init(oauthConfigurationWrapper: OAuthConfigurationWrapper, keychainWrapper: KeychainWrapper) {
    self.oauthConfigurationWrapper = oauthConfigurationWrapper
    self.keychainWrapper = keychainWrapper
    }
}

// MARK: - FollowingListInteractorInput

extension FollowingListInteractor: FollowingListInteractorInput {
    func numberOfCategories() -> Int {
        return 1
    }
    
    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int {
        return self.following.count
    }
    
    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> FollowingItemProtocol? {
        return following[safe: index]
    }
    
    func retrieve() {
        output?.notifyLoading()
        guard let accesstoken = try? self.keychainWrapper.findPassword() else {
            output?.notifyServerError()
            return
        }
        
        self.oauthConfigurationWrapper.retrieveMyFollowing(with: accesstoken, success: { [weak self] usersResponse in
            DispatchQueue.global().async {
                self?.following = usersResponse.compactMap {
                    guard let login = $0.login else {
                        return nil
                    }
                    
                    guard let id =  $0.id else {
                        return nil
                    }
                    
                    var ownerAvatarData: Data? = nil
                    if let urlString = $0.avatarURL, let url = URL(string: urlString) {
                        ownerAvatarData = try? Data(contentsOf: url)
                    }
                    
                    return FollowingItem(id: id, login: login, name: $0.name, company: $0.company, ownerAvatarData: ownerAvatarData)
                }
                DispatchQueue.main.async {
                    self?.output?.notifySuccess()
                    if (self?.following.count == 0) {
                        self?.output?.notifyEmptyList()
                    }
                }
            }
        }) { [weak self] error in
            if case let oauthConfigError = error as OAuthConfigurationWrapperError, oauthConfigError == .network {
                self?.output?.notifyNetworkError()
                return
            }
            self?.output?.notifyServerError()
        }
    }
}

private struct FollowingItem: FollowingItemProtocol {
    var id: Int
    var login: String
    var name: String?
    var company: String?
    var ownerAvatarData: Data?
}

