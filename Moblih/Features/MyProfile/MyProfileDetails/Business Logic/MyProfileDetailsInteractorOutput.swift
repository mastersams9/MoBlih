//
//  MyProfileDetailsInteractorOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol MyProfileDetailsItemProtocol {
    var login: String { get }
    var name: String? { get }
    var company: String? { get }
    var numberOfRepos: Int { get }
    var ownerAvatarData: Data? { get }
    var followings: Int { get }
    var followers: Int { get }
}

public protocol MyProfileDetailsInteractorOutput: class {

    func notifyLoading()
    func loadUserProfile(_ userProfile: MyProfileDetailsItemProtocol)
    func notifyServerError()
    func notifyNetworkError()
    func routeToFollowing()
    func routeToFollowers()
}
