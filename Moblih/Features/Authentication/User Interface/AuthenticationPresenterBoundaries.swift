//
//  AuthenticationPresenterBoundaries.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol AuthenticationPresenterInput {
    func viewDidLoad()
    func loginButtonDidTouchUpInside()
}

protocol AuthenticationPresenterNavigationConfigurationViewModelProtocol {
    var barTintColor: UIColor { get }
    var title: String { get }
}

protocol AuthenticationPresenterOutput {
    func setNavigationConfiguration(_ navigationConfiguration: AuthenticationPresenterNavigationConfigurationViewModelProtocol)
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func updateLoadingVisibility(_ isHidden: Bool)
    func updateLoginButtonVisibility(_ isHidden: Bool)
    func startLoading()
    func stopLoading()
}
