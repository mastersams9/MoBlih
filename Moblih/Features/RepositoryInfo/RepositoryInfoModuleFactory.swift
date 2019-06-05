//
//  RepositoryInfoModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class RepositoryInfoModuleFactory {
    
    func makeView(id: Int) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "RepositoryInformation", bundle: nil)
        let repositoryInfoViewController = storyboard.instantiateViewController(withIdentifier: "RepositoryInfoViewController") as? RepositoryInfoViewController

        let oauthConfigurationWrapper = OAuthConfigurationWrapper()
        let keychainWrapper = KeychainWrapper()
        
        let interactor = RepositoryInfoInteractor(oauthConfigurationWrapper: oauthConfigurationWrapper, keychainWrapper: keychainWrapper, id: id)
        let presenter = RepositoryInfoPresenter(interactor: interactor)
        
        interactor.output = presenter
        repositoryInfoViewController?.presenter = presenter
        presenter.output = repositoryInfoViewController
        
        return repositoryInfoViewController ?? UIViewController()
    }
}
