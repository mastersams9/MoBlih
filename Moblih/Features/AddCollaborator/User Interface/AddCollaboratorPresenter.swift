//
//  AddCollaboratorPresenter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

final class AddCollaboratorPresenter {
    
    // MARK: - Property
    
    weak var output: AddCollaboratorPresenterOutput?
    private let interactor: AddCollaboratorInteractorInput
    private let router: AddCollaboratorRouterInput
    
    // MARK: - Lifecycle
    
    init(interactor: AddCollaboratorInteractorInput,
         router: AddCollaboratorRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Converting
    
}

// MARK: - AddCollaboratorPresenterInput

extension AddCollaboratorPresenter: AddCollaboratorPresenterInput {
    func addButtonDidTouchUpInside() {
        interactor.prepareAdd()
    }
}

// MARK: - AddCollaboratorInteractorOutput

extension AddCollaboratorPresenter: AddCollaboratorInteractorOutput {
    func notifySuccess() {
        output?.delegateSuccess()
    }
    
    func notifyLoading() {
        output?.delegateLoading()
    }
    
    func routeToAddCollaboratorEdition() {
        router.routeToAddCollaboratorEdition()
    }
}
