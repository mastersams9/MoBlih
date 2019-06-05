//
//  AppRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 10/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol AppRouterProtocol {
    func makeViewController(eventInput: inout AuthenticationInteractorEventInput?) -> UIViewController?
}

class AppRouter: AppRouterProtocol {

    // MARK: - Property
    
    private let keychainWrapper: KeychainWrapperInput

    // MARK: - Lifecycle

    init(keychainWrapper: KeychainWrapperInput) {
        self.keychainWrapper = keychainWrapper
    }

    // MARK: - Privates

    func makeViewController(eventInput: inout AuthenticationInteractorEventInput?) -> UIViewController? {
        if let accessToken = try? keychainWrapper.findPassword(), accessToken != nil {
            return AppModuleFactory().tabBarModules()
        }
        return AuthenticationModuleFactory().makeView(eventInput: &eventInput)
    }
}
