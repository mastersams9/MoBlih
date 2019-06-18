//
//  AddFollowerPresenter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

final class AddFollowerPresenter {

  // MARK: - Property

  weak var output: AddFollowerPresenterOutput?
  private var interactor: AddFollowerInteractorInput

  // MARK: - Lifecycle

  init(interactor: AddFollowerInteractorInput) {
      self.interactor = interactor
  }

  // MARK: - Converting

}

// MARK: - AddFollowerPresenterInput

extension AddFollowerPresenter: AddFollowerPresenterInput {

    func addButtonDidTouchUpInside() {
        interactor.request()
    }

    func confirmButtonDidTouchUpInside() {
        interactor.confirm()
    }

    func textfieldDidUpdateText(_ text: String?) {
        interactor.updateFollowerUsername(text)
    }
}

// MARK: - AddFollowerInteractorOutput

extension AddFollowerPresenter: AddFollowerInteractorOutput {
    func notifyLoading() {
        output?.delegateLoading()
    }
    
    func notifySuccess() {
        output?.delegateSuccess()
    }

    func notifyServerError() {
        output?.delegateServerError(message: "Oops! A Server Error occured")
    }

    func notifyNetworkError() {
        output?.delegateNetworkError(message: "No internet connection.")
    }

    func notifyEmptyUsernameError() {
        output?.delegateServerError(message: "Oops! A Server Error occured due to invalid username")
    }

    func notifyRequest() {
        output?.displayAlertView(text: "Ajouter une personne à suivre",
                                 message: "Veuillez entrer le nom d'utilisateur de la personne à ajouter.",
                                 confirmationTitle: "OK",
                                 cancelTitle: "Annuler")
    }
}
