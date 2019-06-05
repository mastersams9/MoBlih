//
//  AuthenticationPresenter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AuthenticationPresenter
{
    var view: AuthenticationPresenterOutput? = nil
    private var interactor: AuthenticationInteractorInput
    private var router: AuthenticationRouterInput?
    
    init(interactor: AuthenticationInteractorInput,
         router: AuthenticationRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension AuthenticationPresenter: AuthenticationPresenterInput {

    func viewDidLoad() {
        interactor.prepare()
    }
    
    func loginButtonDidTouchUpInside() {
        interactor.execute()
    }
}

extension AuthenticationPresenter: AuthenticationInteractorOutput {

    func setDefaultValues() {
        view?.setNavigationConfiguration(AuthenticationPresenterNavigationConfigurationViewModel(
            barTintColor: .lightGray,
            title: "Connexion")
        )
        view?.stopLoading()
        view?.updateLoadingVisibility(true)
        view?.updateLoginButtonVisibility(false)
    }

    func notifyLoading() {
        view?.updateLoadingVisibility(false)
        view?.updateLoginButtonVisibility(true)
        view?.startLoading()
    }

    func didAuthenticationSucceed() {
        router?.presentMainMenuInterface()
    }

    func showServerError() {
        view?.stopLoading()
        view?.updateLoadingVisibility(true)
        view?.updateLoginButtonVisibility(false)
        view?.displayAlertPopupWithTitle("Server Error", message: "Oops! a server error occured. Please try again later.", confirmationTitle: "OK")
    }
    
    func showNetworkError() {
        view?.stopLoading()
        view?.updateLoadingVisibility(true)
        view?.updateLoginButtonVisibility(false)
        view?.displayAlertPopupWithTitle("Network Error", message: "Please check your connectivity.", confirmationTitle: "OK")
    }
}


private struct AuthenticationPresenterNavigationConfigurationViewModel: AuthenticationPresenterNavigationConfigurationViewModelProtocol {
    var barTintColor: UIColor
    var title: String
}
