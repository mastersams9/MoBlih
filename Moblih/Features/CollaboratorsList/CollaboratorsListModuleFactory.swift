//
//  CollaboratorsListModuleFactory.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class CollaboratorsListModuleFactory {

    func makeView() -> CollaboratorsListTableViewController? {

        let keychainWrapper = KeychainWrapper()
        let moblihAPI = MoblihAPI()
        let githubAPIRepository = GithubAPIRepository(api: moblihAPI,
                                                      keychainWrapper: keychainWrapper)

        let interactor = CollaboratorsListInteractor(githubAPIRepository: githubAPIRepository,
                                                     repositoryInformationRepository: RepositoryInformationRepository.shared,
                                                     collaboratorToDeleteRepository: CollaboratorToDeleteRepository.shared)
        let router = CollaboratorsListRouter()
        let presenter = CollaboratorsListPresenter(interactor: interactor, router: router)
        interactor.output = presenter

        let addCollaboratorModuleFactory = AddCollaboratorModuleFactory()
        let removeCollaboratorModuleFactory = RemoveCollaboratorModuleFactory()
        let storyboard = UIStoryboard(name: "CollaboratorsList", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CollaboratorsListTableViewController") as? CollaboratorsListTableViewController
        viewController?.presenter = presenter
        viewController?.addCollaboratorModuleFactory = addCollaboratorModuleFactory
        viewController?.removeCollaboratorModuleFactory = removeCollaboratorModuleFactory
        presenter.output = viewController
        router.viewController = viewController
        addCollaboratorModuleFactory.delegate = viewController
        removeCollaboratorModuleFactory.delegate = viewController

        return viewController
    }
}
