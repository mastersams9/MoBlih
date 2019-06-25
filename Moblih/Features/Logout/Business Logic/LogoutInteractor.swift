//
//  LogoutInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class LogoutInteractor {

    // MARK: - Property

    weak var output: LogoutInteractorOutput?
    private let keychainWrapper: KeychainWrapperInput
    private let collaboratorToDeleteRepository: CollaboratorToDeleteRepositoryInput
    private let followerToDeleteRepository: FollowerToDeleteRepositoryInput
    private let repositoryInformationRepository: RepositoryInformationRepositoryProtocol

    // MARK: - Lifecycle

    init(keychainWrapper: KeychainWrapperInput,
         collaboratorToDeleteRepository: CollaboratorToDeleteRepositoryInput,
         followerToDeleteRepository: FollowerToDeleteRepositoryInput,
         repositoryInformationRepository: RepositoryInformationRepositoryProtocol) {
        self.keychainWrapper = keychainWrapper
        self.collaboratorToDeleteRepository = collaboratorToDeleteRepository
        self.followerToDeleteRepository = followerToDeleteRepository
        self.repositoryInformationRepository = repositoryInformationRepository
    }
}

// MARK: - LogoutInteractorInput

extension LogoutInteractor: LogoutInteractorInput {

    func execute() {
        output?.notifyLoading()
        collaboratorToDeleteRepository.clear(success: nil, failure: nil)
        followerToDeleteRepository.clear(success: nil, failure: nil)
        repositoryInformationRepository.clear(success: nil, failure: nil)
        try? keychainWrapper.deletePassword()
        output?.notifySuccess()
    }
}
