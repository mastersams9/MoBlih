//
//  CollaboratorsListInteractorOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public enum CollaboratorsListCategory: Int {
    case add = 0
}

public protocol CollaboratorsItemProtocol {
    var login: String { get }
    var permission: UserPermission? { get }
    var ownerAvatarData: Data? { get }
}

public protocol CollaboratorsListInteractorOutput: class {
    func notifySuccess()
    func notifyLoading()
    func notifyEmptyList()
    func notifyServerError()
    func notifyNetworkError()
    func updateCategories(_ categories: [CollaboratorsListCategory])
    func notifyInvalidCollaboratorError()
    func notifyConfirmationDelete()
    func notifyUnknownError()
    func notifyDeletedCollaborator(at index: Int, forCategoryIndex categoryIndex: Int)
}
