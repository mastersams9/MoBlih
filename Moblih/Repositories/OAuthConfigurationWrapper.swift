//
//  OAuthConfigurationWrapper.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Octokit

protocol OAuthConfigurationWrapperUserItemProtocol {
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

}

protocol OAuthConfigurationWrapperRepositoryItemProtocol {
    var id: Int? { get }
    var owner: OAuthConfigurationWrapperUserItemProtocol? { get }
    var name: String? { get }
    var fullName: String? { get }
    var isPrivate: Bool? { get }
    var repositoryDescription: String? { get }
    var isFork: Bool? { get }
    var gitURL: String? { get }
    var sshURL: String? { get }
    var cloneURL: String? { get }
    var htmlURL: String? { get }
    var size: Int? { get }
    var lastPush: Date? { get }
}

enum OAuthConfigurationWrapperError: Error {
    case network
    case server
}

protocol OAuthConfigurationWrapperProtocol {
    
    func authenticate() -> URL?
    func handleOpenURL(_ url: URL, completion: @escaping (String?) -> Void)
    func retrieveUserInformations(with accessToken: String?,
                                  success: ((OAuthConfigurationWrapperUserItemProtocol) -> Void)?,
                                  failure: ((OAuthConfigurationWrapperError) -> Void)?)
    func retrieveMyRepositories(with accessToken: String?,
                                success: (([OAuthConfigurationWrapperRepositoryItemProtocol]) -> Void)?,
                                failure: ((OAuthConfigurationWrapperError) -> Void)?)
    func retrieveMyStars(with accessToken: String?,
                         success: (([OAuthConfigurationWrapperRepositoryItemProtocol]) -> Void)?,
                         failure: ((OAuthConfigurationWrapperError) -> Void)?)
    func retrieveMyFollowers(with accessToken: String?,
                             success: (([OAuthConfigurationWrapperUserItemProtocol]) -> Void)?,
                             failure: ((OAuthConfigurationWrapperError) -> Void)?)
    
    func retrieveMyFollowing(with accessToken: String?,
                             success: (([OAuthConfigurationWrapperUserItemProtocol]) -> Void)?,
                             failure: ((OAuthConfigurationWrapperError) -> Void)?)
}

class OAuthConfigurationWrapper: OAuthConfigurationWrapperProtocol {
    
    private let config: OAuthConfiguration
    
    init() {
        self.config = OAuthConfiguration(token: "c522eeb6c222056a4ef8", secret: "8c3d8a717f89ef3d9836c1d76f1072316d435dce", scopes: ["user", "repo", "read:org"])
    }
    
    func authenticate() -> URL? {
        return config.authenticate()
    }

    func handleOpenURL(_ url: URL, completion: @escaping (String?) -> Void) {
        config.handleOpenURL(url: url) { tokenConfiguration in
            completion(tokenConfiguration.accessToken)
        }
    }

    func retrieveUserInformations(with accessToken: String?,
                                  success: ((OAuthConfigurationWrapperUserItemProtocol) -> Void)?,
                                  failure: ((OAuthConfigurationWrapperError) -> Void)?) {
        let tokenConfig = TokenConfiguration(accessToken)
        _ = Octokit(tokenConfig).me() { response in
            switch response {
            case .success(let user):
                DispatchQueue.main.async {
                    success?(OAuthConfigurationWrapperUserItem(id: user.id,
                                                               login: user.login,
                                                               avatarURL: user.avatarURL,
                                                               gravatarID: user.gravatarID,
                                                               type: user.type,
                                                               name: user.name,
                                                               company: user.company,
                                                               blog: user.blog,
                                                               location: user.location,
                                                               email: user.email,
                                                               numberOfPublicRepos: user.numberOfPublicRepos,
                                                               numberOfPublicGists: user.numberOfPublicGists,
                                                               numberOfPrivateRepos: user.numberOfPrivateRepos))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if (error as NSError).code == -1009 {
                        failure?(OAuthConfigurationWrapperError.network)
                        return
                    }
                    failure?(OAuthConfigurationWrapperError.server)
                }
            }
        }
    }

    func retrieveMyStars(with accessToken: String?,
                         success: (([OAuthConfigurationWrapperRepositoryItemProtocol]) -> Void)?,
                         failure: ((OAuthConfigurationWrapperError) -> Void)?) {
        let tokenConfig = TokenConfiguration(accessToken)
        _ = Octokit(tokenConfig).myStars() { response in
            switch response {
            case .success(let repositories):
                let myRepositories = repositories.map { repository -> OAuthConfigurationWrapperRepositoryItemProtocol in
                    let user = repository.owner
                    let owner = OAuthConfigurationWrapperUserItem(id: user.id,
                                                                  login: user.login,
                                                                  avatarURL: user.avatarURL,
                                                                  gravatarID: user.gravatarID,
                                                                  type: user.type,
                                                                  name: user.name,
                                                                  company: user.company,
                                                                  blog: user.blog,
                                                                  location: user.location,
                                                                  email: user.email,
                                                                  numberOfPublicRepos: user.numberOfPublicRepos,
                                                                  numberOfPublicGists: user.numberOfPublicGists,
                                                                  numberOfPrivateRepos: user.numberOfPrivateRepos)
                    return OAuthConfigurationWrapperRepositoryItem(id: repository.id,
                                                                   owner: owner,
                                                                   name: repository.name,
                                                                   fullName: repository.fullName,
                                                                   isPrivate: repository.isPrivate,
                                                                   repositoryDescription: repository.repositoryDescription,
                                                                   isFork: repository.isFork,
                                                                   gitURL: repository.gitURL,
                                                                   sshURL: repository.sshURL,
                                                                   cloneURL: repository.cloneURL,
                                                                   htmlURL: repository.htmlURL,
                                                                   size: repository.size,
                                                                   lastPush: repository.lastPush)
                }
                DispatchQueue.main.async {
                    success?(myRepositories)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if (error as NSError).code == -1009 {
                        failure?(OAuthConfigurationWrapperError.network)
                        return
                    }
                    failure?(OAuthConfigurationWrapperError.server)
                }
            }
        }
    }
    
    func retrieveMyRepositories(with accessToken: String?,
                                success: (([OAuthConfigurationWrapperRepositoryItemProtocol]) -> Void)?,
                                failure: ((OAuthConfigurationWrapperError) -> Void)?) {
        let tokenConfig = TokenConfiguration(accessToken)
        _ = Octokit(tokenConfig).repositories() { response in
            switch response {
            case .success(let repositories):
                let myRepositories = repositories.map { repository -> OAuthConfigurationWrapperRepositoryItemProtocol in
                    let user = repository.owner
                    let owner = OAuthConfigurationWrapperUserItem(id: user.id,
                                                                  login: user.login,
                                                                  avatarURL: user.avatarURL,
                                                                  gravatarID: user.gravatarID,
                                                                  type: user.type,
                                                                  name: user.name,
                                                                  company: user.company,
                                                                  blog: user.blog,
                                                                  location: user.location,
                                                                  email: user.email,
                                                                  numberOfPublicRepos: user.numberOfPublicRepos,
                                                                  numberOfPublicGists: user.numberOfPublicGists,
                                                                  numberOfPrivateRepos: user.numberOfPrivateRepos)
                    return OAuthConfigurationWrapperRepositoryItem(id: repository.id,
                                                                   owner: owner,
                                                                   name: repository.name,
                                                                   fullName: repository.fullName,
                                                                   isPrivate: repository.isPrivate,
                                                                   repositoryDescription: repository.repositoryDescription,
                                                                   isFork: repository.isFork,
                                                                   gitURL: repository.gitURL,
                                                                   sshURL: repository.sshURL,
                                                                   cloneURL: repository.cloneURL,
                                                                   htmlURL: repository.htmlURL,
                                                                   size: repository.size,
                                                                   lastPush: repository.lastPush)
                }
                DispatchQueue.main.async {
                    success?(myRepositories)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if (error as NSError).code == -1009 {
                        failure?(OAuthConfigurationWrapperError.network)
                        return
                    }
                    failure?(OAuthConfigurationWrapperError.server)
                }
            }
        }
    }
    
    func retrieveMyFollowers(with accessToken: String?, success: (([OAuthConfigurationWrapperUserItemProtocol]) -> Void)?, failure: ((OAuthConfigurationWrapperError) -> Void)?) {
        let tokenConfig = TokenConfiguration(accessToken)
        _ = Octokit(tokenConfig).myFollowers() { response in
            switch response {
            case .success(let users):
                let myFollowers = users.map { user -> OAuthConfigurationWrapperUserItemProtocol in
                    return OAuthConfigurationWrapperUserItem(id: user.id,
                                                                  login: user.login,
                                                                  avatarURL: user.avatarURL,
                                                                  gravatarID: user.gravatarID,
                                                                  type: user.type,
                                                                  name: user.name,
                                                                  company: user.company,
                                                                  blog: user.blog,
                                                                  location: user.location,
                                                                  email: user.email,
                                                                  numberOfPublicRepos: user.numberOfPublicRepos,
                                                                  numberOfPublicGists: user.numberOfPublicGists,
                                                                  numberOfPrivateRepos: user.numberOfPrivateRepos)
                }
                DispatchQueue.main.async {
                    success?(myFollowers)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if (error as NSError).code == -1009 {
                        failure?(OAuthConfigurationWrapperError.network)
                        return
                    }
                    failure?(OAuthConfigurationWrapperError.server)
                }
            }
        }
    }
    
    func retrieveMyFollowing(with accessToken: String?, success: (([OAuthConfigurationWrapperUserItemProtocol]) -> Void)?, failure: ((OAuthConfigurationWrapperError) -> Void)?) {
        let tokenConfig = TokenConfiguration(accessToken)
        _ = Octokit(tokenConfig).myFollowing() { response in
            switch response {
            case .success(let users):
                let myFollowers = users.map { user -> OAuthConfigurationWrapperUserItemProtocol in
                    return OAuthConfigurationWrapperUserItem(id: user.id,
                                                             login: user.login,
                                                             avatarURL: user.avatarURL,
                                                             gravatarID: user.gravatarID,
                                                             type: user.type,
                                                             name: user.name,
                                                             company: user.company,
                                                             blog: user.blog,
                                                             location: user.location,
                                                             email: user.email,
                                                             numberOfPublicRepos: user.numberOfPublicRepos,
                                                             numberOfPublicGists: user.numberOfPublicGists,
                                                             numberOfPrivateRepos: user.numberOfPrivateRepos)
                }
                DispatchQueue.main.async {
                    success?(myFollowers)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if (error as NSError).code == -1009 {
                        failure?(OAuthConfigurationWrapperError.network)
                        return
                    }
                    failure?(OAuthConfigurationWrapperError.server)
                }
            }
        }
    }
    
}

// MARK: - Privates

private struct OAuthConfigurationWrapperUserItem: OAuthConfigurationWrapperUserItemProtocol {
    var id: Int?
    var login: String?
    var avatarURL: String?
    var gravatarID: String?
    var type: String?
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var numberOfPublicRepos: Int?
    var numberOfPublicGists: Int?
    var numberOfPrivateRepos: Int?
}

private struct OAuthConfigurationWrapperRepositoryItem: OAuthConfigurationWrapperRepositoryItemProtocol {
    var id: Int?
    var owner: OAuthConfigurationWrapperUserItemProtocol?
    var name: String?
    var fullName: String?
    var isPrivate: Bool?
    var repositoryDescription: String?
    var isFork: Bool?
    var gitURL: String?
    var sshURL: String?
    var cloneURL: String?
    var htmlURL: String?
    var size: Int?
    var lastPush: Date?
}
