//
//  RepositoryInfoInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class RepositoryInfoInteractor {
    // MARK: - Property
    
    weak var output: RepositoryInfoInteractorOutput?
    private let githubAPIRepository: GithubAPIRepositoryProtocol
    private let repositoryInformationRepository: RepositoryInformationRepositoryProtocol
    private var repository: RepositoryItem?
    
    // MARK: - Lifecycle
    
    init(githubAPIRepository: GithubAPIRepositoryProtocol,
         repositoryInformationRepository: RepositoryInformationRepositoryProtocol) {
        self.githubAPIRepository = githubAPIRepository
        self.repositoryInformationRepository = repositoryInformationRepository
    }
    
    // MARK: - Lifecycle
    
    private func checkPermissions(for repository: RepositoryItem) {
        githubAPIRepository.retrieveUserInformations(success: { [weak self] user in
            if user.id == repository.ownerId {
                self?.output?.enableManageCollaboratorsEdition()
                return
            }
            
            guard let owner = repository.ownerName,
                let username = user.login else { return }
            
            self?.githubAPIRepository.retrieveCollaboratorPermission(owner: owner,
                                                                     repositoryName: repository.name,
                                                                     username: username,
                                                                     success: { [weak self] permission in
                                                                        if permission.permission == .admin {
                                                                            self?.output?.enableManageCollaboratorsEdition()
                                                                        }
                }, failure: nil)
            }, failure: nil)
    }
    
    private func retrieveRepo(owner: String, repoName: String) {
        githubAPIRepository.retrieveRepository(owner: owner, repositoryName: repoName, success: { [weak self] repositoryResponse in
            guard let name = repositoryResponse.name else {
                return
            }
            
            guard let id =  repositoryResponse.id else {
                return
            }
            
            var ownerAvatarData: Data? = nil
            if let urlString = repositoryResponse.owner?.avatarURL, let url = URL(string: urlString) {
                ownerAvatarData = try? Data(contentsOf: url)
            }
            let repository = RepositoryItem(id: id,
                                              name: name,
                                              description: repositoryResponse.description,
                                              isPrivate: repositoryResponse.isPrivate ?? false,
                                              ownerId: repositoryResponse.owner?.id,
                                              ownerName: repositoryResponse.owner?.login,
                                              ownerAvatarData: ownerAvatarData,
                                              lastUpdatedDate: repositoryResponse.lastPush,
                                              starCount: repositoryResponse.stargazersCount ?? 0,
                                              watchersCount: repositoryResponse.watchersCount ?? 0,
                                              defaultBranch: repositoryResponse.defaultBranch)
            self?.repository = repository
            self?.checkPermissions(for: repository)
            self?.output?.notifySuccess(repository: repository)
            }, failure: { [weak self] error in
                                                switch error {
                                                case .network:
                                                    self?.output?.notifyNetworkError()
                                                case .noData:
                                                    self?.output?.notifyNoDataError()
                                                default:
                                                    self?.output?.notifyServerError()
                                                }
        })
    }
}

// MARK: - MyRepositoriesInteractorInput

extension RepositoryInfoInteractor: RepositoryInfoInteractorInput {
    func refresh() {
        retrieve()
    }
    
    func retrieve() {
        output?.notifyLoading()
        output?.disableManageCollaboratorsEdition()
        
        repositoryInformationRepository.get(success: { [weak self] repoInfoResponse in
            guard let owner = repoInfoResponse.owner, let repoName = repoInfoResponse.name else { return }
            self?.retrieveRepo(owner: owner, repoName: repoName)
        }) { [weak self] _ in
            self?.output?.notifyServerError()
        }
    }
    
    func prepareManageCollaborators() {
        repositoryInformationRepository.save(owner: repository?.ownerName,
                                             name: repository?.name,
                                             success: { [weak self] in
                                                self?.output?.routeToManageCollaborators()
        }) { [weak self] _ in
            self?.output?.notifyServerError()
        }
    }
}

private struct RepositoryItem: RepositoryInfoRepositoryItemProtocol {
    var id: Int
    var name: String
    var description: String?
    var isPrivate: Bool
    var ownerId: Int?
    var ownerName: String?
    var ownerAvatarData: Data?
    var lastUpdatedDate: Date?
    var starCount: Int
    var watchersCount: Int
    var defaultBranch: String?
}
