//
//  AuthenticationRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AuthenticationRouter: AuthenticationRouterInput
{    
    func presentMainMenuInterface() {
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = AppModuleFactory().tabBarModules()
    }
}
