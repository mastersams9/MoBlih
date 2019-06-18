//
//  AddRepositoryModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 31/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AddRepositoryModuleFactory {
    
    func makeView(delegate: AddRepositoryTableViewControllerDelegate? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "AddRepository", bundle: nil)
        let addRepositoryTableViewController = storyboard.instantiateViewController(withIdentifier: "AddRepositoryTableViewController") as? AddRepositoryTableViewController

        let keychainWrapper = KeychainWrapper()
        let githubAPIRepository = GithubAPIRepository(api: MoblihAPI(),
                                                      keychainWrapper: keychainWrapper)
        let interactor = AddRepositoryInteractor(githubAPIRepository: githubAPIRepository,
                                                 keychainWrapper: keychainWrapper)
        let router = AddRepositoryRouter()
        router.delegate = delegate
        let presenter = AddRepositoryPresenter(interactor: interactor, router: router)

        interactor.output = presenter
        addRepositoryTableViewController?.presenter = presenter
        presenter.output = addRepositoryTableViewController
        router.viewController = addRepositoryTableViewController

        return addRepositoryTableViewController ?? UIViewController()
    }
}
