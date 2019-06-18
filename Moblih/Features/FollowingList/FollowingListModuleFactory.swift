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

  func makeView() -> FollowingListViewController? {
    
    let storyboard = UIStoryboard(name: "FollowingListStoryboard", bundle: nil)
    let view = storyboard.instantiateViewController(withIdentifier: "FollowingListViewController") as? FollowingListViewController
    
    
    let moblihAPI = MoblihAPI()
    let keychainWrapper = KeychainWrapper()
    let addFollowerModuleFactory = AddFollowerModuleFactory()
    let deleteFollowerModuleFactory = DeleteFollowerModuleFactory()
    let githubAPIRepository = GithubAPIRepository(api: moblihAPI,
                                                  keychainWrapper: keychainWrapper)
    let interactor = FollowingListInteractor(githubAPIRepository: githubAPIRepository,
                                             followerToDeleteRepository: FollowerToDeleteRepository.shared)
    let router = FollowingListRouter()
    let presenter = FollowingListPresenter(interactor: interactor, router: router)
    
    interactor.output = presenter
    view?.presenter = presenter
    view?.addFollowerModuleFactory = addFollowerModuleFactory
    view?.deleteFollowerModuleFactory = deleteFollowerModuleFactory
    presenter.output = view
    addFollowerModuleFactory.delegate = view
    deleteFollowerModuleFactory.delegate = view
    router.viewController = view

    return view
  }
}
