//
//  AddCollaboratorEditionInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

private enum AddCollaboratorEditionInteractorUserPermission {
    case admin
    case push
    case pull
}

class AddCollaboratorEditionInteractor {
    // MARK: - Property

    weak var output: AddCollaboratorEditionInteractorOutput?

    private var permissions: [AddCollaboratorEditionInteractorUserPermission] = [.admin, .push, .pull]
    private var selectedPermission: AddCollaboratorEditionInteractorUserPermission = .push
    private var login: String?

    private let githubAPIRepository: GithubAPIRepositoryProtocol
    private let repositoryInformationRepository: RepositoryInformationRepositoryProtocol

    // MARK: - Lifecycle

    init(githubAPIRepository: GithubAPIRepositoryProtocol,
         repositoryInformationRepository: RepositoryInformationRepositoryProtocol) {
        self.githubAPIRepository = githubAPIRepository
        self.repositoryInformationRepository = repositoryInformationRepository
    }

    private func addCollaboratorEditionInteractorPermissionCategory(from userPermission: AddCollaboratorEditionInteractorUserPermission?) -> AddCollaboratorEditionInteractorPermissionCategory? {
        switch userPermission {
        case .admin?:
            return .admin
        case .push?:
            return .push
        case .pull?:
            return .pull
        default:
            return nil
        }
    }

    private func githubAPIRepositoryUserPermission(from userPermission: AddCollaboratorEditionInteractorUserPermission?) -> GithubAPIRepositoryUserPermission? {
        switch userPermission {
        case .admin?:
            return .admin
        case .push?:
            return .push
        case .pull?:
            return .pull
        default:
            return nil
        }
    }

    private func addCollaborator(owner: String,
                                 repositoryName: String,
                                 username: String) {

        githubAPIRepository.addCollaborator(owner: owner,
                                            repositoryName: repositoryName,
                                            username: username,
                                            permission: githubAPIRepositoryUserPermission(from: selectedPermission),
                                            success: { [weak self] in
                                                self?.output?.notifyAddCollaboratorSuccess()
                                                self?.output?.routeBack()

        }) { [weak self] (error) in
            switch error {
            case .network:
                self?.output?.notifyNetworkError()
            case .noData:
                self?.output?.notifyNoData()
            case .unknown:
                self?.output?.notifyCollaboratorAlreadyExistsError()
            default:
                self?.output?.notifyServerError()
            }
        }
    }
}

// MARK: - AddCollaboratorEditionInteractorInput

extension AddCollaboratorEditionInteractor: AddCollaboratorEditionInteractorInput {

    func retrieve() {
        output?.setDefaultValues()
        output?.notifyLoading()
        output?.updateCategories()
        if let section = permissions.firstIndex(of: selectedPermission) {
            output?.selectPermission(section: section)
        }
    }

    func execute() {
        guard let login = self.login, !login.isEmpty else {
            output?.notifyEmptyLoginError()
            return
        }
        repositoryInformationRepository.get(success: { [weak self] repositoryInfoResponse in

            guard let owner = repositoryInfoResponse.owner, let repositoryName = repositoryInfoResponse.name else {
                self?.output?.notifyServerError()
                return
            }

            self?.addCollaborator(owner: owner,
                                  repositoryName: repositoryName,
                                  username: login)
        }) { [weak self] _ in
            self?.output?.notifyServerError()
        }
    }

    func updateLogin(_ login: String?) {
        self.login = login
    }

    func numberOfSections() -> Int {
        return permissions.count
    }

    func sectionCategory(at section: Int) -> AddCollaboratorEditionInteractorPermissionCategory? {
        return addCollaboratorEditionInteractorPermissionCategory(from: permissions[safe: section])
    }

    func selectPermission(at section: Int) {
        if let permission = permissions[safe: section] {
            selectedPermission = permission
            output?.selectPermission(section: section)
            return
        }
    }
}
