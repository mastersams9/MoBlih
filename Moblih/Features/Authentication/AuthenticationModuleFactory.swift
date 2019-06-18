//
//  AuthenticationModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

struct AuthenticationModuleFactory {
    
    func makeView(eventInput: inout AuthenticationInteractorEventInput?) -> UIViewController? {
        
        let oauthConfigurationWrapper = OAuthConfigurationWrapper()

        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let authenticationViewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController") as? AuthenticationViewController
        let repository = AuthenticationRepository(viewController: authenticationViewController)
        let keychainWrapper = KeychainWrapper()
        let moblihAPI = MoblihAPI()
        let githubAPIRepository = GithubAPIRepository(api: moblihAPI,
                                                      keychainWrapper: keychainWrapper)
        let interactor = AuthenticationInteractor(repository: repository,
                                                  oauthConfigurationWrapper: oauthConfigurationWrapper,
                                                  githubAPIRepository: githubAPIRepository,
                                                  keychainWrapper: keychainWrapper)
        let router = AuthenticationRouter()
        let presenter = AuthenticationPresenter(interactor: interactor, router: router)
        
        eventInput = interactor
        repository.output = interactor
        interactor.output = presenter
        presenter.view = authenticationViewController
        authenticationViewController?.presenter = presenter
        return authenticationViewController
    }
}
