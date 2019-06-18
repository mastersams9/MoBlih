//
//  MyRepositoriesRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class MyRepositoriesRouter {

    // MARK: - Property

    weak var viewController: MyRepositoriesViewController?

    // MARK: - Lifecycle

    init() { }
}

// MARK: - MyRepositoriesRouterInput

extension MyRepositoriesRouter: MyRepositoriesRouterInput {

    public func routeToAddingRepository() {
        let addRepositoryViewController = AddRepositoryModuleFactory().makeView(delegate: viewController)
        viewController?.navigationController?.pushViewController(addRepositoryViewController,
                                                                 animated: true)
    }
    
    public func routeToRepositoryInformations() {
        
        let repositoryInfoViewController = RepositoryInfoModuleFactory().makeView()
        
        viewController?.navigationController?.pushViewController(repositoryInfoViewController,
                                                                 animated: true)
    }
}
