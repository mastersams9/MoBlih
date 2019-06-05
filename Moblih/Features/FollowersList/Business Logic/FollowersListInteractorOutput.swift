//
//  FollowersListInteractorOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol FollowersItemProtocol {
    var login: String { get }
    var name: String? { get }
    var company: String? { get }
    var ownerAvatarData: Data? { get }
}

public protocol FollowersListInteractorOutput: class {
    func notifySuccess()
    func notifyLoading()
    func notifyEmptyList()
    func notifyServerError()
    func notifyNetworkError()
}
