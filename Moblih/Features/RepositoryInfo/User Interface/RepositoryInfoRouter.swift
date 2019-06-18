//
//  RepositoryInfoRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class RepositoryInfoRouter {

    weak var viewController: UIViewController?
}

// MARK: - RepositoryInfoRouterInput

extension RepositoryInfoRouter: RepositoryInfoRouterInput{

    func routeToManageCollaborators() {
        if let collaboratorsListViewController = CollaboratorsListModuleFactory().makeView() {
            viewController?.navigationController?.pushViewController(collaboratorsListViewController,
                                                                 animated: true)
        }
    }
}
