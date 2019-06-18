//
//  CollaboratorsListRouter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

open class CollaboratorsListRouter {

  // MARK: - Property

  public weak var viewController: UIViewController?

  // MARK: - Lifecycle

  public init() { }
}

// MARK: - CollaboratorsListRouterInput

extension CollaboratorsListRouter: CollaboratorsListRouterInput {

    public func routeToRepositoryInfo() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
}
