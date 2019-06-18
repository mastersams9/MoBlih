//
//  RemoveCollaboratorInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class RemoveCollaboratorInteractor {
    // MARK: - Property
    
    private let githubAPIRepository: GithubAPIRepositoryProtocol
    private let collaboratorToDeleteRepository: CollaboratorToDeleteRepositoryInput
    private let repositoryInformationRepository: RepositoryInformationRepositoryProtocol
    weak var output: RemoveCollaboratorInteractorOutput?
    
    // MARK: - Lifecycle
    
    init(githubAPIRepository: GithubAPIRepositoryProtocol,
         collaboratorToDeleteRepository: CollaboratorToDeleteRepositoryInput,
         repositoryInformationRepository: RepositoryInformationRepositoryProtocol) {
        self.githubAPIRepository = githubAPIRepository
        self.collaboratorToDeleteRepository = collaboratorToDeleteRepository
        self.repositoryInformationRepository = repositoryInformationRepository
    }
    
    private func prepareCollaboratorToDelete(with owner: String, and repositoryName: String) {
        collaboratorToDeleteRepository.get(success: { [weak self] usernameToDelete in
            guard let self = self else { return }
            if owner == usernameToDelete {
                self.output?.notifyRemoveSameOwnerAndCollaboratorError()
                return
            }
            self.githubAPIRepository.removeCollaborator(owner: owner, repositoryName: repositoryName, username: usernameToDelete, success: { [weak self] in
                guard let self = self else { return }
                self.output?.notifySuccess()
                }, failure: { [weak self] error in
                    if case let githubAPIRepositoryError = error as GithubAPIRepositoryError,
                        githubAPIRepositoryError == .network {
                        self?.output?.notifyNetworkError()
                        return
                    }
                    self?.output?.notifyServerError()
            })
        }) { [weak self] error in
            if case let collaboratorToDeleteRepositoryError = error as CollaboratorToDeleteRepositoryError,
                collaboratorToDeleteRepositoryError == .noData {
                self?.output?.notifyServerError()
                return
            }
            self?.output?.notifyServerError()
        }
    }
}

// MARK: - RemoveCollaboratorInteractorInput

extension RemoveCollaboratorInteractor: RemoveCollaboratorInteractorInput {
    func execute() {
        output?.notifyLoading()
        repositoryInformationRepository.get(success: { [weak self] repoInfoResponse in
            guard let self = self else { return }
            guard let owner = repoInfoResponse.owner, let repoName = repoInfoResponse.name else {
                self.output?.notifyServerError()
                return
            }
            self.prepareCollaboratorToDelete(with: owner,
                                             and: repoName)
        }) { [weak self] _ in
            self?.output?.notifyServerError()
        }
    }
}
