//
//  AddCollaboratorRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AddCollaboratorRouter {
    
    weak var parentViewController: UIViewController?
}

// MARK: - AddCollaboratorRouterInput

extension AddCollaboratorRouter: AddCollaboratorRouterInput {
    
    func routeToAddCollaboratorEdition() {
        
        if let addCollaboratorEditionVC = AddCollaboratorEditionModuleFactory().makeView() {
            parentViewController?.navigationController?.pushViewController(addCollaboratorEditionVC,
                                                                           animated: true)
        }
    }
}
