//
//  AuthenticationViewController.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicatiorView: UIActivityIndicatorView!

    var presenter: AuthenticationPresenterInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonDidTouchUpInside(_ sender: UIButton) {
        presenter?.loginButtonDidTouchUpInside()
    }
}

extension AuthenticationViewController: AuthenticationPresenterOutput {

    func setNavigationConfiguration(_ navigationConfiguration: AuthenticationPresenterNavigationConfigurationViewModelProtocol) {
        navigationController?.navigationBar.barTintColor = navigationConfiguration.barTintColor
        navigationItem.title = navigationConfiguration.title
    }

    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }

    func updateLoadingVisibility(_ isHidden: Bool) {
        activityIndicatiorView.isHidden = isHidden
    }
    
    func updateLoginButtonVisibility(_ isHidden: Bool) {
        loginButton.isHidden = isHidden
    }

    func startLoading() {
        activityIndicatiorView.startAnimating()
    }

    func stopLoading() {
        activityIndicatiorView.stopAnimating()
    }
}
