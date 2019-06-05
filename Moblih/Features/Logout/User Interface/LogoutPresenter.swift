//
//  LogoutPresenter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

final class LogoutPresenter {

    // MARK: - Property

    weak var output: LogoutPresenterOutput?
    private var interactor: LogoutInteractorInput

    // MARK: - Lifecycle

    init(interactor: LogoutInteractorInput) {
        self.interactor = interactor
    }

    // MARK: - Converting

}

// MARK: - LogoutPresenterInput

extension LogoutPresenter: LogoutPresenterInput {

    func logoutButtonDidTouchUpInside() {
        interactor.execute()
    }
}

// MARK: - LogoutInteractorOutput

extension LogoutPresenter: LogoutInteractorOutput {

    func notifyLoading() {
        output?.delegateLoading()
    }

    func notifySuccess() {
        output?.delegateSuccess()
    }
}
