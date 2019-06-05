//
//  AuthenticationInteractorBoundaries.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol AuthenticationInteractorEventInput {
    func handleUrl(_ url: URL)
}

protocol AuthenticationInteractorInput {
    func prepare()
    func execute()
}

protocol AuthenticationInteractorOutput {
    func setDefaultValues()
    func notifyLoading()
    func didAuthenticationSucceed()
    func showServerError()
    func showNetworkError()
}
