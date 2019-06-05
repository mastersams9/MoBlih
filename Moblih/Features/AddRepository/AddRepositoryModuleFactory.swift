//
//  AddRepositoryModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 31/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AddRepositoryModuleFactory {
    
    func makeView() -> UIViewController {
        let storyboard = UIStoryboard(name: "AddRepository", bundle: nil)
        let addRepositoryViewController = storyboard.instantiateViewController(withIdentifier: "AddRepositoryViewController") as? AddRepositoryViewController

        let oauthConfigurationWrapper = OAuthConfigurationWrapper()
        let keychainWrapper = KeychainWrapper()
        let interactor = AddRepositoryInteractor(oauthConfigurationWrapper: oauthConfigurationWrapper, keychainWrapper: keychainWrapper)
        let router = AddRepositoryRouter()
        let presenter = AddRepositoryPresenter(interactor: interactor, router: router)

        interactor.output = presenter
        addRepositoryViewController?.presenter = presenter
        presenter.output = addRepositoryViewController
        router.viewController = addRepositoryViewController

        return addRepositoryViewController ?? UIViewController()
    }
}
