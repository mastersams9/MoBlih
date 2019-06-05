//
//  MyProfileModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class MyProfileModuleFactory {

    func makeView(from viewController: UIViewController?) {

        guard let myProfileViewController = (viewController as? MyProfileViewController) else { return }

        let oauthConfigurationWrapper = OAuthConfigurationWrapper()
        let keychainWrapper = KeychainWrapper()
        let logoutModuleFactory = LogoutModuleFactory()
        let myProfileDetailsModuleFactory = MyProfileDetailsModuleFactory()
        let interactor = MyProfileInteractor(oauthConfigurationWrapper: oauthConfigurationWrapper, keychainWrapper: keychainWrapper)
        let router = MyProfileRouter()
        let presenter = MyProfilePresenter(interactor: interactor, router: router)

        interactor.output = presenter
        myProfileViewController.presenter = presenter
        myProfileViewController.logoutModuleFactory = logoutModuleFactory
        myProfileViewController.myProfileDetailsModuleFactory = myProfileDetailsModuleFactory
        logoutModuleFactory.delegate = myProfileViewController
        myProfileDetailsModuleFactory.delegate = myProfileViewController
        presenter.output = myProfileViewController
        router.viewController = myProfileViewController
    }
}
