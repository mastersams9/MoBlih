//
//  FollowersListModuleFactory.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class FollowersListModuleFactory {
    
    func makeView(withDelegate delegate: FollowersListViewDelegate? = nil) -> FollowersListViewController? {
        
        let storyboard = UIStoryboard(name: "FollowersListStoryboard", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "FollowersListViewController") as? FollowersListViewController
        
        
        let oauthConfigurationWrapper = OAuthConfigurationWrapper()
        let keychainWrapper = KeychainWrapper()
        let interactor = FollowersListInteractor(oauthConfigurationWrapper: oauthConfigurationWrapper, keychainWrapper: keychainWrapper)
        let router = FollowersListRouter()
        let presenter = FollowersListPresenter(interactor: interactor, router: router)
        
        interactor.output = presenter
        view?.presenter = presenter
        presenter.output = view
        router.viewController = view
        
        return view
    }
}
