//
//  AppModuleFactory.swift
//  Moblih
//
//  Created by Sami on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AppModuleFactory {

    // MARK: - TabBar
    
    func tabBarModules() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let tabBarController = storyboard.instantiateInitialViewController() as? MyTabBarController, let viewControllers = tabBarController.viewControllers {
            
            for (_, navigationController) in viewControllers.enumerated() {
                let viewController = (navigationController as? UINavigationController)?.viewControllers.first
                switch viewController {
                case viewController as MyRepositoriesViewController:
                    MyRepositoriesModuleFactory().makeView(from: viewController)
                case viewController as MyProfileViewController:
                    MyProfileModuleFactory().makeView(from: viewController)
                default: break
                }
            }
            return tabBarController
        }
        return nil
    }
}
