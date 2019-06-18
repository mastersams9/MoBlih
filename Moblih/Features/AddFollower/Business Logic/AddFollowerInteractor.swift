//
//  AddFollowerInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class AddFollowerInteractor {
    // MARK: - Property
    private let githubAPIRepository: GithubAPIRepositoryProtocol
    weak var output: AddFollowerInteractorOutput?

    private var username: String?
    // MARK: - Lifecycle

    init(githubAPIRepository: GithubAPIRepositoryProtocol) {
        self.githubAPIRepository = githubAPIRepository
    }
}

// MARK: - AddFollowerInteractorInput

extension AddFollowerInteractor: AddFollowerInteractorInput {
    func request() {
        output?.notifyRequest()
    }
    
    func confirm() {
        guard let username = self.username, !username.isEmpty else {
            output?.notifyEmptyUsernameError()
            return
        }
        output?.notifyLoading()

        self.githubAPIRepository.addFollower(username: username,
                                             success: { [weak self] in
                                                DispatchQueue.main.async {
                                                    self?.output?.notifySuccess()
                                                }
        }) { [weak self] error in
            if case let githubAPIRepositoryError = error as GithubAPIRepositoryError,
                githubAPIRepositoryError == .network {
                self?.output?.notifyNetworkError()
                return
            }
            self?.output?.notifyServerError()
        }
    }

    func updateFollowerUsername(_ username: String?) {
        self.username = username
    }
}
