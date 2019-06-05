//
//  FollowingListModuleFactory.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class FollowingListModuleFactory {

  func makeView(withDelegate delegate: FollowingListViewDelegate? = nil) -> FollowingListViewController? {
    
    let storyboard = UIStoryboard(name: "FollowingListStoryboard", bundle: nil)
    let view = storyboard.instantiateViewController(withIdentifier: "FollowingListViewController") as? FollowingListViewController
    
    
    let oauthConfigurationWrapper = OAuthConfigurationWrapper()
    let keychainWrapper = KeychainWrapper()
    let interactor = FollowingListInteractor(oauthConfigurationWrapper: oauthConfigurationWrapper, keychainWrapper: keychainWrapper)
    let router = FollowingListRouter()
    let presenter = FollowingListPresenter(interactor: interactor, router: router)
    
    interactor.output = presenter
    view?.presenter = presenter
    presenter.output = view
    router.viewController = view
    
    return view
  }
}
