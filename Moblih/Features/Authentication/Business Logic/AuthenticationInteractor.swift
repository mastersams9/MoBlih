//
//  AuthenticationInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class AuthenticationInteractor
{
    // MARK: - Property
    var output: AuthenticationInteractorOutput? = nil
    private let repository: AuthenticationRepositoryInput
    private let oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol
    private let keychainWrapper: KeychainWrapperInput
    
    init(repository: AuthenticationRepositoryInput,
         oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol,
         keychainWrapper: KeychainWrapperInput) {
        self.repository = repository
        self.oauthConfigurationWrapper = oauthConfigurationWrapper
        self.keychainWrapper = keychainWrapper
    }
}

extension AuthenticationInteractor: AuthenticationInteractorInput {

    func prepare() {
        output?.setDefaultValues()
    }
    
    func execute() {
        output?.notifyLoading()
        let url = oauthConfigurationWrapper.authenticate()
        repository.load(url)
    }
}

extension AuthenticationInteractor: AuthenticationRepositoryOutput {

    func didReceiveBadUrlError() {
        output?.showServerError()
    }

    func didFinish() {
        output?.setDefaultValues()
    }
}

extension AuthenticationInteractor: AuthenticationInteractorEventInput {

    func handleUrl(_ url: URL) {
        oauthConfigurationWrapper.handleOpenURL(url) { [weak self] accessToken in
            guard let self = self else { return }
            guard let accessToken = accessToken else {
                self.repository.quit {
                    self.output?.showServerError()
                }
                return
            }
            self.oauthConfigurationWrapper.retrieveUserInformations(with: accessToken,
                                                                    success: { userInformation in
                                                                        self.repository.quit {
                                                                            guard let accountName = userInformation.login else {
                                                                                self.output?.showServerError()
                                                                                return
                                                                            }
                                                                            do {
                                                                                try self.keychainWrapper.save(accessToken: accessToken,
                                                                                                              accountName: accountName)
                                                                                self.output?.didAuthenticationSucceed()
                                                                            } catch {
                                                                                self.output?.showServerError()
                                                                            }
                                                                        }
            }, failure: { error in
                self.repository.quit {
                    if error == .network {
                        self.output?.showNetworkError()
                        return
                    }
                    self.output?.showServerError()
                }
            })
        }
    }
}
