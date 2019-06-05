//
//  AddRepositoryInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class AddRepositoryInteractor {

    // MARK: - Property

    weak var output: AddRepositoryInteractorOutput?

    private let oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol
    private let keychainWrapper: KeychainWrapperInput

    // MARK: - Lifecycle

    init(oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol,
         keychainWrapper: KeychainWrapperInput) {
        self.oauthConfigurationWrapper = oauthConfigurationWrapper
        self.keychainWrapper = keychainWrapper
    }
}

// MARK: - AddRepositoryInteractorInput

extension AddRepositoryInteractor: AddRepositoryInteractorInput {

}
