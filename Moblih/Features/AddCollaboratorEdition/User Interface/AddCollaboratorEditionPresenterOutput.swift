//
//  AddCollaboratorEditionPresenterOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol AddCollaboratorEditionViewModelPlaceholdersProtocol {
    var viewTitle: String { get }
    var usernameLogin: String { get }
    var permissionsText: String { get }
    var addButtonTitleText: String { get }
}

protocol AddCollaboratorEditionPresenterOutput: class {

    func startLoader()
    func stopLoader()
    func reloadSegmentedControl()
    func selectSegmentedControl(at index: Int)
    func setErrorNameText(_ text: String?)
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func setPlaceHolders(placeholder: AddCollaboratorEditionViewModelPlaceholdersProtocol)
    func displayLogin(_ login: String)
}
