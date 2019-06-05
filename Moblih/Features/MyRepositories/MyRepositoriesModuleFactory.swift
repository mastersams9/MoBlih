//
//  MyRepositoriesModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class MyRepositoriesModuleFactory {

    func makeView(from viewController: UIViewController?) {

        guard let myRepositoriesViewController = (viewController as? MyRepositoriesViewController) else { return }
        let oauthConfigurationWrapper = OAuthConfigurationWrapper()
        let keychainWrapper = KeychainWrapper()
        
        let interactor = MyRepositoriesInteractor(oauthConfigurationWrapper: oauthConfigurationWrapper, keychainWrapper: keychainWrapper)
        let router = MyRepositoriesRouter()
        let presenter = MyRepositoriesPresenter(interactor: interactor, router: router)

        interactor.output = presenter
        myRepositoriesViewController.presenter = presenter
        presenter.output = myRepositoriesViewController
        router.viewController = myRepositoriesViewController
    }
}
