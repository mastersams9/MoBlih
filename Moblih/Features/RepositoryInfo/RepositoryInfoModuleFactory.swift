//
//  RepositoryInfoModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class RepositoryInfoModuleFactory {
    
    func makeView() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "RepositoryInformation", bundle: nil)
        let repositoryInfoViewController = storyboard.instantiateViewController(withIdentifier: "RepositoryInfoViewController") as? RepositoryInfoViewController

        let keychainWrapper = KeychainWrapper()
        let githubAPIRepository = GithubAPIRepository(api: MoblihAPI(),
                                                            keychainWrapper: keychainWrapper)
        
        let interactor = RepositoryInfoInteractor(githubAPIRepository: githubAPIRepository,
                                                  repositoryInformationRepository: RepositoryInformationRepository.shared)
        let router = RepositoryInfoRouter()
        let presenter = RepositoryInfoPresenter(interactor: interactor,
                                                router: router)
        
        interactor.output = presenter
        repositoryInfoViewController?.presenter = presenter
        presenter.output = repositoryInfoViewController
        router.viewController = repositoryInfoViewController
        
        return repositoryInfoViewController ?? UIViewController()
    }
}
