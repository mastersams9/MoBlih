//
//  AddRepositoryPresenterOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol AddRepositoryViewModelPlaceholdersProtocol {
    var name: String { get }
    var description: String { get }
    var addReadmeText: String { get }
    var privateText: String { get }
    var createButtonTitleText: String { get }
}

protocol AddRepositoryPresenterOutput: class {
    func startLoader()
    func stopLoader()
    func displayName(_ name: String)
    func setErrorNameText(_ text: String?)
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func setPlaceHolders(placeholder: AddRepositoryViewModelPlaceholdersProtocol)
    func updatePrivateSwitchEnability(_ enabled: Bool)
    func updateAddReadmeSwitchEnability(_ enabled: Bool)
}
