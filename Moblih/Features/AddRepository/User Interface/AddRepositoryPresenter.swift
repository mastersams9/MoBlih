//
//  AddRepositoryPresenter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

final class AddRepositoryPresenter {

    // MARK: - Property

    weak var output: AddRepositoryPresenterOutput?
    private var interactor: AddRepositoryInteractorInput
    private var router: AddRepositoryRouterInput

    // MARK: - Lifecycle

    init(interactor: AddRepositoryInteractorInput, router: AddRepositoryRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Converting

}

// MARK: - AddRepositoryPresenterInput

extension AddRepositoryPresenter: AddRepositoryPresenterInput {
    func addReadmeSwitchValueDidChange(_ value: Bool) {
        interactor.updateAddReadmeValue(value: value)
    }
    
    func privateSwitchValueDidChange(_ value: Bool) {
        interactor.updateIsPrivateValue(value: value)
    }
    

    func viewDidLoad() {
        interactor.retrieve()
    }

    func nameTextfieldDidUpdateText(_ text: String?) {
        interactor.updateNameText(text: text!)
    }

    func descriptionTextfieldDidUpdateText(_ text: String?) {
        interactor.updateDescriptionText(text: text!)
    }

    func didTapCreateButton() {
        interactor.create()
    }
}

// MARK: - AddRepositoryInteractorOutput

extension AddRepositoryPresenter: AddRepositoryInteractorOutput {
    
    func notifyLoading() {
        output?.startLoader()
    }
    
    func setDefaultValues() {
        let placeholder = AddRepositoryViewModelPlaceholders(name: "Name",
                                                             description: "Description (Optional)",
                                                             addReadmeText: "Add Readme",
                                                             privateText: "Private",
                                                             createButtonTitleText: "Create")
        
        output?.setPlaceHolders(placeholder: placeholder)
    }
    
    func notifyNetworkError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Network error", message: "Oops ! Seems to be no connexion.", confirmationTitle: "OK")
    }
    
    func notifyServerError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Server error", message: "Oops ! An error occured. Please try again.", confirmationTitle: "OK")
    }
    
    func notifyRepositoryAlreadyExistsError() {
        output?.stopLoader()
        output?.setErrorNameText("Repository already exists.")
    }
    
    func notifyNoData() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Error", message: "Oops ! An error occured. Please try again.", confirmationTitle: "OK")
    }
    
    func notifyCreationSuccess() {
        output?.stopLoader()
    }
    
    func notifyEmptyNameError() {
        output?.stopLoader()
        output?.setErrorNameText("Name cannot be empty")
    }
    
    func routeToMyRepositories() {
        output?.stopLoader()
        router.routeToMyRepositories()
    }

    func updateName(_ name: String) {
        output?.setErrorNameText(nil)
        output?.displayName(name)
    }

    func enableAddReadme() {
        output?.updateAddReadmeSwitchEnability(true)
    }
    
    func disableAddReadme() {
        output?.updateAddReadmeSwitchEnability(false)
    }
    
    func enablePrivate() {
        output?.updatePrivateSwitchEnability(true)
    }
    
    func disablePrivate() {
        output?.updatePrivateSwitchEnability(false)
    }
}

private struct AddRepositoryViewModelPlaceholders: AddRepositoryViewModelPlaceholdersProtocol {
    var name: String
    var description: String
    var addReadmeText: String
    var privateText: String
    var createButtonTitleText: String
}
