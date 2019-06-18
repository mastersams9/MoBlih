//
//  RemoveCollaboratorPresenter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

final class RemoveCollaboratorPresenter {
    
    // MARK: - Property
    
    weak var output: RemoveCollaboratorPresenterOutput?
    private var interactor: RemoveCollaboratorInteractorInput
    
    // MARK: - Lifecycle
    
    init(interactor: RemoveCollaboratorInteractorInput) {
        self.interactor = interactor
    }
    
    // MARK: - Converting
    
}

// MARK: - RemoveCollaboratorPresenterInput

extension RemoveCollaboratorPresenter: RemoveCollaboratorPresenterInput {
    func viewDidLoad() {
        interactor.execute()
    }
}

// MARK: - RemoveCollaboratorInteractorOutput

extension RemoveCollaboratorPresenter: RemoveCollaboratorInteractorOutput {
    func notifyLoading() {
        output?.startLoader()
    }
    
    func notifySuccess() {
        output?.stopLoader()
        output?.delegateSuccess()
    }
    
    func notifyServerError() {
        output?.stopLoader()
        output?.delegateServerError(message: "Oops! A Server Error occured")
    }
    
    func notifyRemoveSameOwnerAndCollaboratorError() {
        output?.stopLoader()
        output?.delegateServerError(message: "Cannot remove this collaborator because it's the repository's owner.")
    }
    
    func notifyNetworkError() {
        output?.stopLoader()
        output?.delegateNetworkError(message: "No internet connection.")
    }
}
