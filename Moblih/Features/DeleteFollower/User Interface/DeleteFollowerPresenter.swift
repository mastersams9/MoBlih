//
//  DeleteFollowerPresenter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

final class DeleteFollowerPresenter {

    // MARK: - Property

    weak var output: DeleteFollowerPresenterOutput?
    private var interactor: DeleteFollowerInteractorInput

    // MARK: - Lifecycle

    init(interactor: DeleteFollowerInteractorInput) {
        self.interactor = interactor
    }

    // MARK: - Converting

}

// MARK: - DeleteFollowerPresenterInput

extension DeleteFollowerPresenter: DeleteFollowerPresenterInput {
    func viewDidLoad() {
        interactor.execute()
    }
}

// MARK: - DeleteFollowerInteractorOutput

extension DeleteFollowerPresenter: DeleteFollowerInteractorOutput {

    func notifyLoading() {
        output?.startLoader()
    }

    func notifySuccess() {
        output?.stopLoader()
        output?.delegateSuccess()
    }

    func notifyServerError() {
        output?.stopLoader()
        output?.delegateServerError(message: "Oops! A Server Error occured")
    }

    func notifyNetworkError() {
        output?.stopLoader()
        output?.delegateNetworkError(message: "No internet connection.")
    }
}
