//
//  AddRepositoryRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

open class AddRepositoryRouter {

  // MARK: - Property

  public weak var viewController: UIViewController?
    public weak var delegate: AddRepositoryTableViewControllerDelegate?

  // MARK: - Lifecycle

  public init() { }
}

// MARK: - AddRepositoryRouterInput

extension AddRepositoryRouter: AddRepositoryRouterInput {

    public func routeToMyRepositories() {
        delegate?.addRepositoryTableViewControllerDidFinish()
        viewController?.navigationController?.popViewController(animated: true)
    }
}
