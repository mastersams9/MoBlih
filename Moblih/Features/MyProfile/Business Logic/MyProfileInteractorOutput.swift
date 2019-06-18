//
//  MyProfileInteractorOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public enum Category: Int {
    case logout = 0
    case myProfileDetails
}

public protocol MyProfileInteractorOutput: class {

    func updateCategories(_ categories: [Category])
    func notifyLoading()
    func routeToAuthentication()
    func notifyServerError()
    func notifyNetworkError()
    func notifySuccess()
    func presentFollowingView()
    func presentFollowersView()
    func routeToRepositoryInformation()
}
