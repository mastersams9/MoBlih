//
//  AddCollaboratorInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class AddCollaboratorInteractor {
    // MARK: - Property
    weak var output: AddCollaboratorInteractorOutput?
    
    // MARK: - Lifecycle
    
    init() {}
}

// MARK: - AddCollaboratorInteractorInput

extension AddCollaboratorInteractor: AddCollaboratorInteractorInput {
    func prepareAdd() {
        output?.notifyLoading()
        output?.routeToAddCollaboratorEdition()
        output?.notifySuccess()
    }
}
