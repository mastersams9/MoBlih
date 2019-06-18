//
//  DeleteFollowerInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class DeleteFollowerInteractor {
    // MARK: - Property

    weak var output: DeleteFollowerInteractorOutput?
    private let githubAPIRepository: GithubAPIRepositoryProtocol
    private let followerToDeleteRepository: FollowerToDeleteRepositoryInput

    // MARK: - Lifecycle
    
    init(githubAPIRepository: GithubAPIRepositoryProtocol,
         followerToDeleteRepository: FollowerToDeleteRepositoryInput) {
        self.githubAPIRepository = githubAPIRepository
        self.followerToDeleteRepository = followerToDeleteRepository
    }
}

// MARK: - DeleteFollowerInteractorInput

extension DeleteFollowerInteractor: DeleteFollowerInteractorInput {

    func execute() {
        output?.notifyLoading()
        followerToDeleteRepository.get(success: { [weak self] usernameToDelete in
            guard let self = self else { return }
            self.githubAPIRepository.unfollow(username: usernameToDelete, success: { [weak self]  in
                self?.output?.notifySuccess()
            }, failure: { [weak self] error in
                if case let githubAPIRepositoryError = error as GithubAPIRepositoryError,
                    githubAPIRepositoryError == .network {
                    self?.output?.notifyNetworkError()
                    return
                }
                self?.output?.notifyServerError()
            })
        }) { [weak self] error in
            if case let followerToDeleteRepositoryError = error as FollowerToDeleteRepositoryError,
                followerToDeleteRepositoryError == .noData {
                self?.output?.notifyServerError()
                return
            }
            self?.output?.notifyServerError()
        }
    }
}
