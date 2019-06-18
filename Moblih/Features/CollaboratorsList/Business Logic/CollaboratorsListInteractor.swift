//
//  CollaboratorsListInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class CollaboratorsListInteractor {
    // MARK: - Property

    weak var output: CollaboratorsListInteractorOutput?
    private let githubAPIRepository: GithubAPIRepositoryProtocol
    private let repositoryInformationRepository: RepositoryInformationRepositoryProtocol
    private let collaboratorToDeleteRepository: CollaboratorToDeleteRepositoryInput
    private var collaborators: [CollaboratorsItem] = []
    private var collaboratorToDelete: String?

    // MARK: - Lifecycle

    init(githubAPIRepository: GithubAPIRepositoryProtocol,
         repositoryInformationRepository: RepositoryInformationRepositoryProtocol,
         collaboratorToDeleteRepository: CollaboratorToDeleteRepositoryInput) {
        self.githubAPIRepository = githubAPIRepository
        self.repositoryInformationRepository = repositoryInformationRepository
        self.collaboratorToDeleteRepository = collaboratorToDeleteRepository
    }
}

// MARK: - CollaboratorsListInteractorInput

extension CollaboratorsListInteractor: CollaboratorsListInteractorInput {
    func numberOfCategories() -> Int {
        return 1
    }

    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int {
        return collaborators.count
    }

    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> CollaboratorsItemProtocol? {
        return collaborators[safe: index]
    }



    func retrieve() {
        output?.updateCategories([.add])
        output?.notifyLoading()

        repositoryInformationRepository.get(success: { [weak self] response in
            guard let self = self else { return }
            guard let repositoryOwner = response.owner, let repositoryName = response.name else {
                self.output?.notifyServerError()
                return
            }
            self.githubAPIRepository.retrieveCollaborators(owner: repositoryOwner,
                                                      repositoryName: repositoryName,
                                                      success: { [weak self] collaboratorsResponse in
                                                        DispatchQueue.global().async {
                                                            self?.collaborators = collaboratorsResponse.compactMap {
                                                                guard let login = $0.login else {
                                                                    return nil
                                                                }

                                                                guard let id =  $0.id else {
                                                                    return nil
                                                                }

                                                                var ownerAvatarData: Data? = nil
                                                                if let urlString = $0.avatarURL, let url = URL(string: urlString) {
                                                                    ownerAvatarData = try? Data(contentsOf: url)
                                                                }

                                                                var permission: UserPermission? = nil
                                                                if let permissions = $0.permissions {
                                                                    if permissions.admin == true {
                                                                        permission = .admin
                                                                    } else if permissions.push == true {
                                                                        permission = .push
                                                                    } else if permissions.pull == true {
                                                                        permission = .pull
                                                                    }
                                                                }

                                                                return CollaboratorsItem(id: id,
                                                                                         login: login,
                                                                                         permission: permission,
                                                                                         ownerAvatarData: ownerAvatarData)
                                                            }
                                                            DispatchQueue.main.async {
                                                                self?.output?.notifySuccess()
                                                                if self?.collaborators.count == 0 {
                                                                    self?.output?.notifyEmptyList()
                                                                }
                                                            }
                                                        }
            }) { [weak self] error in
                if case let githubAPIRepositoryError = error as GithubAPIRepositoryError, githubAPIRepositoryError == .network {
                    self?.output?.notifyNetworkError()
                    return
                }
                self?.output?.notifyServerError()
            }

        }) { [weak self] _ in
            self?.output?.notifyServerError()
        }
    }

    func refresh() {
        retrieve()
    }

    func refreshAfterDelete() {
        DispatchQueue.global().async {
            if let index = self.collaborators.firstIndex(where: { $0.login == self.collaboratorToDelete }) {
                self.collaborators.remove(at: index)
                DispatchQueue.main.async {
                    self.output?.notifyDeletedCollaborator(at: Int(index), forCategoryIndex: 0)
                }
            }
        }
    }

    func prepareDelete(at index: Int, forCategoryIndex categoryIndex: Int) {
        guard let collaborator = collaborators[safe: index] else {
            output?.notifyInvalidCollaboratorError()
            return
        }
        collaboratorToDeleteRepository.save(login: collaborator.login,
                                        success: { [weak self] in
                                            self?.collaboratorToDelete = collaborator.login
                                            self?.output?.notifyConfirmationDelete()
        }) { [weak self] _ in
            self?.output?.notifyUnknownError()
        }
    }

}

private struct CollaboratorsItem: CollaboratorsItemProtocol {
    var id: Int
    var login: String
    var permission: UserPermission?
    var ownerAvatarData: Data?
}
