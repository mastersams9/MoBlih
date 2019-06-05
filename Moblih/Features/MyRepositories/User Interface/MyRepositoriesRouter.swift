//
//  MyRepositoriesRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

open class MyRepositoriesRouter {

  // MARK: - Property

  public weak var viewController: UIViewController?

  // MARK: - Lifecycle

  public init() { }
}

// MARK: - MyRepositoriesRouterInput

extension MyRepositoriesRouter: MyRepositoriesRouterInput {

    public func routeToAddingRepository() {
        let addRepositoryViewController = AddRepositoryModuleFactory().makeView()
        viewController?.navigationController?.pushViewController(addRepositoryViewController,
                                                                 animated: true)
    }
    
    public func routeToRepositoryInformations(with id: Int) {
        
        let repositoryInfoViewController = RepositoryInfoModuleFactory().makeView(id: id)
        
        viewController?.navigationController?.pushViewController(repositoryInfoViewController,
                                                                 animated: true)
    }
}
