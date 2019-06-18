//
//  FollowingListInteractorOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public enum FollowingListCategory: Int {
    case add = 0
}

public protocol FollowingItemProtocol {
    var login: String { get }
    var name: String? { get }
    var company: String? { get }
    var ownerAvatarData: Data? { get }
}

public protocol FollowingListInteractorOutput: class {
    func notifyEmptyList()
    func notifySuccess()
    func notifyLoading()
    func notifyServerError()
    func notifyNetworkError()
    func notifyInvalidFollowerError()
    func updateCategories(_ categories: [FollowingListCategory])
    func notifyConfirmationDelete()
    func notifyUnknownError()
    func notifyDeletedFollower(at index: Int, forCategoryIndex categoryIndex: Int)
}
