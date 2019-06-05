//
//  LogoutInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class LogoutInteractor {

    // MARK: - Property

    weak var output: LogoutInteractorOutput?
    private let keychainWrapper: KeychainWrapperInput

    // MARK: - Lifecycle

    init(keychainWrapper: KeychainWrapperInput) {
        self.keychainWrapper = keychainWrapper
    }
}

// MARK: - LogoutInteractorInput

extension LogoutInteractor: LogoutInteractorInput {

    func execute() {
        output?.notifyLoading()
        try? keychainWrapper.deletePassword()
        output?.notifySuccess()
    }
}
