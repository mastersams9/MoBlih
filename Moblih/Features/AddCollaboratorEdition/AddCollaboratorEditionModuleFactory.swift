//
//  AddCollaboratorEditionModuleFactory.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AddCollaboratorEditionModuleFactory {

  func makeView() -> AddCollaboratorEditionViewController? {

    let keychainWrapper = KeychainWrapper()
    let githubAPIRepository = GithubAPIRepository(api: MoblihAPI(),
                                                  keychainWrapper: keychainWrapper)

    let interactor = AddCollaboratorEditionInteractor(githubAPIRepository: githubAPIRepository,
                                                      repositoryInformationRepository: RepositoryInformationRepository.shared)
    let router = AddCollaboratorEditionRouter()
    let presenter = AddCollaboratorEditionPresenter(interactor: interactor, router: router)
    interactor.output = presenter

    let storyboard = UIStoryboard(name: "AddCollaboratorEdition", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "AddCollaboratorEditionViewController") as? AddCollaboratorEditionViewController
    viewController?.presenter = presenter
    presenter.output = viewController
    router.viewController = viewController

    return viewController
  }
}
