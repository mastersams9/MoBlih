//
//  GithubAPIRepository.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

enum GithubAPIRepositoryUserPermission: String {
    case admin
    case push
    case pull
}

class GithubAPIRepository {

    private enum Constants {
        static let baseURL = "https://api.github.com"
        static let placeholderOwner = "$owner"
        static let placeholderRepository = "$repo"
        static let placeholderUsername = "$username"
        static let userURL = "\(baseURL)/user"
        static let repositoriesURL = "\(userURL)/repos"
        static let repositoryURL = "\(baseURL)/repos/\(placeholderOwner)/\(placeholderRepository)"
        static let collaboratorsURL = "\(baseURL)/repos/\(placeholderOwner)/\(placeholderRepository)/collaborators"
        static let collaboratorURL = "\(collaboratorsURL)/\(placeholderUsername)"
        static let collaboratorPermissionURL = "\(collaboratorURL)/permission"
        static let followingsURL = "\(userURL)/following"
        static let followersURL = "\(userURL)/followers"
        static let followingURL = "\(userURL)/following/\(placeholderUsername)"
        static let name = "name"
        static let description = "description"
        static let isPrivate = "private"
        static let isReadmeAutoInit = "auto_init"
        static let accessToken = "access_token"
    }

    private let api: MoblihAPI
    private let keychainWrapper: KeychainWrapperInput

    init(api: MoblihAPI,
         keychainWrapper: KeychainWrapperInput) {
        self.api = api
        self.keychainWrapper = keychainWrapper
    }

    private func prepareErrorManagement(from moblihAPIError: MoblihAPIError) -> GithubAPIRepositoryError {
        switch moblihAPIError {
        case .network:
            return .network
        case .server:
            return .server
        case .noData:
            return .noData
        default:
            return .unknown
        }
    }

    private func prepareRepositoryCreationParameters(from request: GithubAPIRepositoryCreationRequestProtocol) -> [String: Any] {
        var params: [String: Any] = [:]
        params.updateValue(request.name, forKey: Constants.name)
        if let description = request.description {
            params.updateValue(description, forKey: Constants.description)
        }
        params.updateValue(request.isPrivate, forKey: Constants.isPrivate)
        params.updateValue(request.isReadmeAutoInit, forKey: Constants.isReadmeAutoInit)
        return params
    }

    private func makeUser(from user: CodableGithubApiRepositoryUserItem?) -> GithubAPIRepositoryUserItemProtocol {
        let userItem = GithubApiRepositoryUserItem(id: user?.id,
                                                   login: user?.login,
                                                   avatarURL: user?.avatarURL,
                                                   gravatarID: user?.gravatarID,
                                                   type: user?.type,
                                                   name: user?.name,
                                                   company: user?.company,
                                                   blog: user?.blog,
                                                   location: user?.location,
                                                   email: user?.email,
                                                   numberOfPublicRepos: user?.numberOfPublicRepos,
                                                   numberOfPublicGists: user?.numberOfPublicGists,
                                                   numberOfPrivateRepos: user?.numberOfPrivateRepos,
                                                   permissions: GithubAPIRepositoryRepositoryPermissionItem(admin: user?.permissions?.admin,
                                                                                                            push: user?.permissions?.push,
                                                                                                            pull: user?.permissions?.pull),
                                                   followers: user?.followers,
                                                   followings: user?.followings)
        return userItem
    }

}

// MARK: - GithubAPIRepositoryProtocol

extension GithubAPIRepository: GithubAPIRepositoryProtocol {

    func retrieveFollowers(success: (([GithubAPIRepositoryUserItemProtocol]) -> Void)?,
                           failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.followersURL,
                    method: .get,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            do {
                                let codableResponse = try JSONDecoder().decode([CodableGithubApiRepositoryUserItem].self, from: data)
                                let followers = codableResponse.map { user -> GithubAPIRepositoryUserItemProtocol in
                                    return self.makeUser(from: user)
                                }
                                DispatchQueue.main.async {
                                    success?(followers)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    failure?(.unknown)
                                }
                            }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }


    func retrieveFollowings(success: (([GithubAPIRepositoryUserItemProtocol]) -> Void)?,
                            failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.followingsURL,
                    method: .get,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            do {
                                let codableResponse = try JSONDecoder().decode([CodableGithubApiRepositoryUserItem].self, from: data)
                                let followings = codableResponse.map { user -> GithubAPIRepositoryUserItemProtocol in
                                    return self.makeUser(from: user)
                                }
                                DispatchQueue.main.async {
                                    success?(followings)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    failure?(.unknown)
                                }
                            }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func addFollower(username: String,
                     success: (() -> Void)?,
                     failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.followingURL
            .replacingOccurrences(of: Constants.placeholderUsername,
                                  with: username),
                    method: .put,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            DispatchQueue.main.async { success?() }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func unfollow(username: String,
                  success: (() -> Void)?,
                  failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.followingURL
            .replacingOccurrences(of: Constants.placeholderUsername,
                                  with: username),
                    method: .delete,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            DispatchQueue.main.async { success?() }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }
    
    func retrieveRepository(owner: String,
                            repositoryName: String,
                            success: ((GithubAPIRepositoryRepositoryItemProtocol) -> Void)?,
                            failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.repositoryURL
            .replacingOccurrences(of: Constants.placeholderOwner,
            with: owner)
            .replacingOccurrences(of: Constants.placeholderRepository, with: repositoryName),
                    method: .get,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            do {
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .formatted(DateFormatter.repoformatter)
                                let codableResponse = try decoder.decode(CodableGithubApiRepositoryItem.self, from: data)
                                let user = codableResponse.owner
                                let owner = self.makeUser(from: user)
                                let repository = GithubAPIRepositoryRepositoryItem(id: codableResponse.id,
                                                                             owner: owner,
                                                                             name: codableResponse.name,
                                                                             fullName: codableResponse.fullName,
                                                                             isPrivate: codableResponse.isPrivate,
                                                                             description: codableResponse.description,
                                                                             isFork: codableResponse.isFork,
                                                                             gitURL: codableResponse.gitURL,
                                                                             sshURL: codableResponse.sshURL,
                                                                             cloneURL: codableResponse.cloneURL,
                                                                             htmlURL: codableResponse.htmlURL,
                                                                             size: codableResponse.size,
                                                                             createdAt: codableResponse.createdAt,
                                                                             updatedAt: codableResponse.updatedAt,
                                                                             lastPush: codableResponse.lastPush,
                                                                             stargazersCount: codableResponse.stargazersCount,
                                                                             watchersCount: codableResponse.watchersCount,
                                                                             language: codableResponse.language,
                                                                             defaultBranch: codableResponse.defaultBranch,
                                                                             permissions: GithubAPIRepositoryRepositoryPermissionItem(admin: codableResponse.permissions?.admin,
                                                                                                                                      push: codableResponse.permissions?.push,
                                                                                                                                      pull: codableResponse.permissions?.pull)
                                    )
                                DispatchQueue.main.async {
                                    success?(repository)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    print(error)
                                    failure?(.unknown)
                                }
                            }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func retrieveMyRepositories(success: (([GithubAPIRepositoryRepositoryItemProtocol]) -> Void)?,
                                failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.repositoriesURL,
                    method: .get,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            do {
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .formatted(DateFormatter.repoformatter)
                                let codableResponse = try decoder.decode([CodableGithubApiRepositoryItem].self, from: data)
                                let myRepositories = codableResponse.map { repository -> GithubAPIRepositoryRepositoryItemProtocol in
                                    let user = repository.owner
                                    let owner = self.makeUser(from: user)
                                    return GithubAPIRepositoryRepositoryItem(id: repository.id,
                                                                             owner: owner,
                                                                             name: repository.name,
                                                                             fullName: repository.fullName,
                                                                             isPrivate: repository.isPrivate,
                                                                             description: repository.description,
                                                                             isFork: repository.isFork,
                                                                             gitURL: repository.gitURL,
                                                                             sshURL: repository.sshURL,
                                                                             cloneURL: repository.cloneURL,
                                                                             htmlURL: repository.htmlURL,
                                                                             size: repository.size,
                                                                             createdAt: repository.createdAt,
                                                                             updatedAt: repository.updatedAt,
                                                                             lastPush: repository.lastPush,
                                                                             stargazersCount: repository.stargazersCount,
                                                                             watchersCount: repository.watchersCount,
                                                                             language: repository.language,
                                                                             defaultBranch: repository.defaultBranch,
                                                                             permissions: GithubAPIRepositoryRepositoryPermissionItem(admin: repository.permissions?.admin,
                                                                                                                                      push: repository.permissions?.push,
                                                                                                                                      pull: repository.permissions?.pull)
                                    )
                                }
                                DispatchQueue.main.async {
                                    success?(myRepositories)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    print(error)
                                    failure?(.unknown)
                                }
                            }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func repositoryCreation(from request: GithubAPIRepositoryCreationRequestProtocol,
                            success: @escaping () -> Void,
                            failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.repositoriesURL,
                    method: .post,
                    accessToken: accessToken,
                    parameters: prepareRepositoryCreationParameters(from: request),
                    success: { data in
                        DispatchQueue.global().async {
                            DispatchQueue.main.async { success() }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func retrieveCollaborators(owner: String,
                               repositoryName: String,
                               success: (([GithubAPIRepositoryUserItemProtocol]) -> Void)?,
                               failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.collaboratorsURL
            .replacingOccurrences(of: Constants.placeholderOwner,
                                  with: owner)
            .replacingOccurrences(of: Constants.placeholderRepository,
                                  with: repositoryName),
                    method: .get,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                                do {
                                    let codableResponse = try JSONDecoder().decode([CodableGithubApiRepositoryUserItem].self, from: data)
                                    let collaborators = codableResponse.map { user -> GithubAPIRepositoryUserItemProtocol in
                                        return self.makeUser(from: user)
                                    }
                                    DispatchQueue.main.async {
                                        success?(collaborators)
                                    }
                                } catch {
                                    DispatchQueue.main.async {
                                        failure?(.unknown)
                                    }
                                }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func retrieveCollaboratorPermission(owner: String,
                                        repositoryName: String,
                                        username: String,
                                        success: ((GithubAPIRepositoryUserPermissionItemProtocol) -> Void)?,
                                        failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.collaboratorPermissionURL
            .replacingOccurrences(of: Constants.placeholderOwner,
                                  with: owner)
            .replacingOccurrences(of: Constants.placeholderRepository,
                                  with: repositoryName)
            .replacingOccurrences(of: Constants.placeholderUsername,
                                  with: username),
                    method: .get,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            do {
                                let codableResponse = try JSONDecoder().decode(CodableGithubAPIRepositoryUserPermissionItem.self, from: data)
                                let permission = GithubAPIRepositoryUserPermissionItem(permission: UserPermission(rawValue: codableResponse.permission ?? "none"))
                                DispatchQueue.main.async {
                                    success?(permission)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    failure?(.unknown)
                        }
                            }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func addCollaborator(owner: String,
                         repositoryName: String,
                         username: String,
                         permission: GithubAPIRepositoryUserPermission?,
                         success: (() -> Void)?,
                         failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }

        var parameters: [String: Any] = [:]
        if let permission = permission {
            parameters = ["permission": permission.rawValue]
        }

        api.request(urlString: Constants.collaboratorURL
            .replacingOccurrences(of: Constants.placeholderOwner,
            with: owner)
            .replacingOccurrences(of: Constants.placeholderRepository,
            with: repositoryName)
            .replacingOccurrences(of: Constants.placeholderUsername,
            with: username),
                    method: .put,
                    accessToken: accessToken,
                    parameters: parameters,
                    success: { data in
                        DispatchQueue.global().async {
                            DispatchQueue.main.async { success?() }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func removeCollaborator(owner: String,
                            repositoryName: String,
                            username: String,
                            success: (() -> Void)?,
                            failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.collaboratorURL
            .replacingOccurrences(of: Constants.placeholderOwner,
                                  with: owner)
            .replacingOccurrences(of: Constants.placeholderRepository,
                                  with: repositoryName)
            .replacingOccurrences(of: Constants.placeholderUsername,
                                  with: username),
                    method: .delete,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            DispatchQueue.main.async { success?() }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func retrieveUserLogin(with accessToken: String,
                           success: ((String) -> Void)?,
                           failure: ((GithubAPIRepositoryError) -> Void)?) {
        api.request(urlString: Constants.userURL,
                    method: .get,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            do {
                                let user = try JSONDecoder().decode(CodableGithubApiRepositoryUserItem.self, from: data)
                                let userItem = self.makeUser(from: user)
                                DispatchQueue.main.async {
                                    guard let login = userItem.login else {
                                        failure?(.noData)
                                        return
                                    }
                                    success?(login)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    failure?(.unknown)
                                }
                            }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }

    func retrieveUserInformations(success: ((GithubAPIRepositoryUserItemProtocol) -> Void)?,
                                  failure: ((GithubAPIRepositoryError) -> Void)?) {
        guard let accessToken = try? keychainWrapper.findPassword() else {
            failure?(.unknown)
            return
        }
        api.request(urlString: Constants.userURL,
                    method: .get,
                    accessToken: accessToken,
                    parameters: [:],
                    success: { data in
                        DispatchQueue.global().async {
                            do {
                                let user = try JSONDecoder().decode(CodableGithubApiRepositoryUserItem.self, from: data)
                                let userItem = self.makeUser(from: user)
                                DispatchQueue.main.async {
                                    success?(userItem)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    failure?(.unknown)
                                }
                            }
                        }
        },
                    failure: { [weak self] in
                        guard let self = self else { return }
                        let error = self.prepareErrorManagement(from: $0)
                        DispatchQueue.main.async {
                            failure?(error)
                        }
        })
    }
}

// MARK: - Privates

private struct GithubAPIRepositoryRepositoryPermissionItem: GithubAPIRepositoryRepositoryPermissionItemProtocol {
    var admin: Bool?
    var push: Bool?
    var pull: Bool?
}

private struct GithubApiRepositoryUserItem: GithubAPIRepositoryUserItemProtocol {
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
    var permissions: GithubAPIRepositoryRepositoryPermissionItemProtocol?
    var followers: Int?
    var followings: Int?
}

private struct GithubAPIRepositoryRepositoryItem: GithubAPIRepositoryRepositoryItemProtocol {
    var id: Int?
    var owner: GithubAPIRepositoryUserItemProtocol?
    var name: String?
    var fullName: String?
    var isPrivate: Bool?
    var description: String?
    var isFork: Bool?
    var gitURL: String?
    var sshURL: String?
    var cloneURL: String?
    var htmlURL: String?
    var size: Int?
    var createdAt: Date?
    var updatedAt: Date?
    var lastPush: Date?
    var stargazersCount: Int?
    var watchersCount: Int?
    var language: String?
    var defaultBranch: String?
    var permissions: GithubAPIRepositoryRepositoryPermissionItemProtocol?
}

private struct CodableGithubApiRepositoryPermissionItem: Codable {
    var admin: Bool?
    var push: Bool?
    var pull: Bool?
}

private struct CodableGithubApiRepositoryUserItem: Codable {
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
    var permissions: CodableGithubApiRepositoryPermissionItem?
    var followers: Int?
    var followings: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case type
        case name
        case company
        case blog
        case location
        case email
        case numberOfPublicRepos = "public_repos"
        case numberOfPublicGists = "public_gists"
        case numberOfPrivateRepos = "total_private_repos"
        case permissions
        case followers
        case followings = "following"
    }
}

private struct CodableGithubApiRepositoryItem: Codable {
    var id: Int?
    var owner: CodableGithubApiRepositoryUserItem?
    var name: String?
    var fullName: String?
    var isPrivate: Bool?
    var description: String?
    var isFork: Bool?
    var gitURL: String?
    var sshURL: String?
    var cloneURL: String?
    var htmlURL: String?
    var size: Int?
    var createdAt: Date?
    var updatedAt: Date?
    var lastPush: Date?
    var stargazersCount: Int?
    var watchersCount: Int?
    var language: String?
    var defaultBranch: String?
    var permissions: CodableGithubApiRepositoryPermissionItem?

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case name
        case fullName
        case isPrivate = "private"
        case description
        case isFork = "fork"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL
        case htmlURL
        case size
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastPush = "pushed_at"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case defaultBranch = "default_branch"
        case permissions
    }
}

public enum UserPermission: String {
    case admin
    case push = "write"
    case pull = "read"
    case none
}

private struct GithubAPIRepositoryUserPermissionItem: GithubAPIRepositoryUserPermissionItemProtocol {
    var permission: UserPermission?
}

private struct CodableGithubAPIRepositoryUserPermissionItem: Codable {
    var permission: String?
}

private extension DateFormatter {
    static let repoformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
