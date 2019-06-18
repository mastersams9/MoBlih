//
//  GithubAPIRepositoryProtocol.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

enum GithubAPIRepositoryError: Error {
    case network
    case server
    case noData
    case unknown
}

protocol GithubAPIRepositoryCreationRequestProtocol: Encodable {
    var name: String { get }
    var description: String? { get }
    var isPrivate: Bool { get }
    var isReadmeAutoInit: Bool { get }
}

protocol GithubAPIRepositoryRepositoryPermissionItemProtocol {
    var admin: Bool? { get }
    var push: Bool? { get }
    var pull: Bool? { get }
}

protocol GithubAPIRepositoryUserItemProtocol {
    var id: Int? { get }
    var login: String? { get }
    var avatarURL: String? { get }
    var gravatarID: String? { get }
    var type: String? { get }
    var name: String? { get }
    var company: String? { get }
    var blog: String? { get }
    var location: String? { get }
    var email: String? { get }
    var numberOfPublicRepos: Int? { get }
    var numberOfPublicGists: Int? { get }
    var numberOfPrivateRepos: Int? { get }
    var followers: Int? { get }
    var followings: Int? { get }
    var permissions: GithubAPIRepositoryRepositoryPermissionItemProtocol? { get }
}

protocol GithubAPIRepositoryRepositoryItemProtocol {
    var id: Int? { get }
    var owner: GithubAPIRepositoryUserItemProtocol? { get }
    var name: String? { get }
    var fullName: String? { get }
    var isPrivate: Bool? { get }
    var description: String? { get }
    var isFork: Bool? { get }
    var gitURL: String? { get }
    var sshURL: String? { get }
    var cloneURL: String? { get }
    var htmlURL: String? { get }
    var size: Int? { get }
    var createdAt: Date? { get }
    var updatedAt: Date? { get }
    var lastPush: Date? { get }
    var stargazersCount: Int? { get }
    var watchersCount: Int? { get }
    var language: String? { get }
    var defaultBranch: String? { get }
    var permissions: GithubAPIRepositoryRepositoryPermissionItemProtocol? { get }
}

protocol GithubAPIRepositoryUserPermissionItemProtocol {
    var permission: UserPermission? { get }
}


protocol GithubAPIRepositoryProtocol {

    func retrieveMyRepositories(success: (([GithubAPIRepositoryRepositoryItemProtocol]) -> Void)?,
                                failure: ((GithubAPIRepositoryError) -> Void)?)
    func retrieveRepository(owner: String,
                            repositoryName: String,
                            success: ((GithubAPIRepositoryRepositoryItemProtocol) -> Void)?,
                            failure: ((GithubAPIRepositoryError) -> Void)?)
    func repositoryCreation(from request: GithubAPIRepositoryCreationRequestProtocol,
                            success: @escaping () -> Void,
                            failure: ((GithubAPIRepositoryError) -> Void)?)
    func retrieveCollaborators(owner: String,
                               repositoryName: String,
                               success: (([GithubAPIRepositoryUserItemProtocol]) -> Void)?,
                               failure: ((GithubAPIRepositoryError) -> Void)?)
    func retrieveCollaboratorPermission(owner: String,
                                        repositoryName: String,
                                        username: String,
                                        success: ((GithubAPIRepositoryUserPermissionItemProtocol) -> Void)?,
                                        failure: ((GithubAPIRepositoryError) -> Void)?)
    func addCollaborator(owner: String,
                         repositoryName: String,
                         username: String,
                         permission: GithubAPIRepositoryUserPermission?,
                         success: (() -> Void)?,
                         failure: ((GithubAPIRepositoryError) -> Void)?)
    func removeCollaborator(owner: String,
                            repositoryName: String,
                            username: String,
                            success: (() -> Void)?,
                            failure: ((GithubAPIRepositoryError) -> Void)?)

    func retrieveUserInformations(success: ((GithubAPIRepositoryUserItemProtocol) -> Void)?,
                                  failure: ((GithubAPIRepositoryError) -> Void)?)
    func retrieveUserLogin(with accessToken: String,
                           success: ((String) -> Void)?,
                            failure: ((GithubAPIRepositoryError) -> Void)?)

    func retrieveFollowers(success: (([GithubAPIRepositoryUserItemProtocol]) -> Void)?,
                           failure: ((GithubAPIRepositoryError) -> Void)?)
    
    func retrieveFollowings(success: (([GithubAPIRepositoryUserItemProtocol]) -> Void)?,
                            failure: ((GithubAPIRepositoryError) -> Void)?)


    func addFollower(username: String,
                     success: (() -> Void)?,
                     failure: ((GithubAPIRepositoryError) -> Void)?)
    func unfollow(username: String,
                  success: (() -> Void)?,
                  failure: ((GithubAPIRepositoryError) -> Void)?)
}
