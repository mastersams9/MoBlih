//
//  RepositoryInfoInteractorOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol RepositoryInfoRepositoryItemProtocol {
    var name: String { get }
    var description: String? { get }
    var isPrivate: Bool { get }
    var ownerName: String? { get }
    var ownerAvatarData: Data? { get }
    var lastUpdatedDate: Date? { get }
    var starCount: Int { get }
    var watchersCount: Int { get }
    var defaultBranch: String? { get }
}

public protocol RepositoryInfoInteractorOutput: class {
    func notifyLoading()
    func notifySuccess(repository: RepositoryInfoRepositoryItemProtocol)
    func notifyNoDataError()
    func notifyServerError()
    func notifyNetworkError()
    func enableManageCollaboratorsEdition()
    func disableManageCollaboratorsEdition()
    func routeToManageCollaborators()
}
