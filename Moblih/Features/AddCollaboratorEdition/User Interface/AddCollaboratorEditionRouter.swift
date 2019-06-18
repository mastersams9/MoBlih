//
//  AddCollaboratorEditionRouter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

open class AddCollaboratorEditionRouter {

  // MARK: - Property

  public weak var viewController: UIViewController?

  // MARK: - Lifecycle

  public init() { }
}

// MARK: - AddCollaboratorEditionRouterInput

extension AddCollaboratorEditionRouter: AddCollaboratorEditionRouterInput {

    public func routeBack() {
        if viewController?.presentingViewController != nil {
            viewController?.dismiss(animated: true, completion: nil)
            return
        }

        viewController?.navigationController?.popViewController(animated: true)
    }
}
