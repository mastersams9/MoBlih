//
//  FollowingListRouter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

open class FollowingListRouter {
    
    // MARK: - Property
    
    public weak var viewController: UIViewController?
    
    // MARK: - Lifecycle
    
    public init() { }
}

// MARK: - FollowingListRouterInput

extension FollowingListRouter: FollowingListRouterInput {
    public func routeToMyProfile() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
