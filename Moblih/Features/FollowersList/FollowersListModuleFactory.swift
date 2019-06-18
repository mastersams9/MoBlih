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
        
        
        let keychainWrapper = KeychainWrapper()
        let moblihAPI = MoblihAPI()
        let githubAPIRepository = GithubAPIRepository(api: moblihAPI,
                                                      keychainWrapper: keychainWrapper)
        let interactor = FollowersListInteractor(githubAPIRepository: githubAPIRepository)
        let router = FollowersListRouter()
        let presenter = FollowersListPresenter(interactor: interactor, router: router)
        
        interactor.output = presenter
        view?.presenter = presenter
        presenter.output = view
        router.viewController = view
        
        return view
    }
}
