//
//  MyProfileRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

open class MyProfileRouter {

    // MARK: - Property

    public weak var viewController: UIViewController?

    // MARK: - Lifecycle

    public init() { }
}

// MARK: - MyProfileRouterInput

extension MyProfileRouter: MyProfileRouterInput {
    public func routeToFollowingView() {
        if let followingListViewController = FollowingListModuleFactory().makeView() {
            viewController?.navigationController?.pushViewController(followingListViewController, animated: true)
        }
    }
    
    public func routeToFollowersView() {
        if let followersListViewController = FollowersListModuleFactory().makeView() {
            viewController?.navigationController?.pushViewController(followersListViewController, animated: true)
        }
    }
    
    public func routeToAuthentication() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = AuthenticationModuleFactory().makeView(eventInput: &appDelegate.eventInput)
    }
}
