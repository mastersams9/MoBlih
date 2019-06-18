//
//  AddCollaboratorEditionPresenter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

final class AddCollaboratorEditionPresenter {

    // MARK: - Property

    weak var output: AddCollaboratorEditionPresenterOutput?
    private var interactor: AddCollaboratorEditionInteractorInput
    private var router: AddCollaboratorEditionRouterInput

    // MARK: - Lifecycle

    init(interactor: AddCollaboratorEditionInteractorInput, router: AddCollaboratorEditionRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Converting

}

// MARK: - AddCollaboratorEditionPresenterInput

extension AddCollaboratorEditionPresenter: AddCollaboratorEditionPresenterInput {

    func viewDidLoad() {
        interactor.retrieve()
    }

    func addButtonDidTouchUpInside() {
        interactor.execute()
    }

    func usernameLoginTextfieldDidUpdateText(_ text: String?) {
        interactor.updateLogin(text)
    }

    func permissionsSegmentedControlDidValueChanged(_ segmentIndex: Int) {
        interactor.selectPermission(at: segmentIndex)
    }

    func numberOfSegments() -> Int {
        return interactor.numberOfSections()
    }

    func titleOfSegments(at index: Int) -> String {
        switch interactor.sectionCategory(at: index) {
        case .admin?:
            return "Admin"
        case .push?:
            return "Push"
        case .pull?:
            return "Pull"
        default:
            return "-"
        }
    }
}

// MARK: - AddCollaboratorEditionInteractorOutput

extension AddCollaboratorEditionPresenter: AddCollaboratorEditionInteractorOutput {

    func setDefaultValues() {
        let placeholder = AddCollaboratorEditionViewModelPlaceholders(viewTitle: "Edition",
                                                                      usernameLogin: "Login",
                                                                      permissionsText: "Permissions", addButtonTitleText: "Add")

        output?.setPlaceHolders(placeholder: placeholder)
    }
    
    func notifyLoading() {
        output?.startLoader()
    }

    func notifyNetworkError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Network error", message: "Oops ! Seems to be no connexion.", confirmationTitle: "OK")
    }

    func notifyServerError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Server error", message: "Oops ! An error occured. Please try again.", confirmationTitle: "OK")
    }

    func notifyCollaboratorAlreadyExistsError() {
        output?.stopLoader()
        output?.setErrorNameText("Collaborator already exists.")
    }

    func notifyNoData() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Error", message: "Oops ! An error occured. Please try again.", confirmationTitle: "OK")
    }

    func notifyAddCollaboratorSuccess() {
        output?.stopLoader()
    }

    func notifyEmptyLoginError() {
        output?.stopLoader()
        output?.setErrorNameText("Login cannot be empty.")
    }

    func updateLogin(_ login: String) {
        output?.setErrorNameText(nil)
        output?.displayLogin(login)
    }

    func updateCategories() {
        output?.stopLoader()
        output?.reloadSegmentedControl()
    }

    func selectPermission(section: Int) {
        output?.selectSegmentedControl(at: section)
    }

    func routeBack() {
        router.routeBack()
    }
}

// MARK: - Privates

private struct AddCollaboratorEditionViewModelPlaceholders: AddCollaboratorEditionViewModelPlaceholdersProtocol {
    var viewTitle: String
    var usernameLogin: String
    var permissionsText: String
    var addButtonTitleText: String
}
