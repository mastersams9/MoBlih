//
//  FollowingListInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class FollowingListInteractor {
    // MARK: - Property

    weak var output: FollowingListInteractorOutput?
    private let githubAPIRepository: GithubAPIRepositoryProtocol
    private var followings: [FollowingItemProtocol] = []
    private let followerToDeleteRepository: FollowerToDeleteRepositoryInput

    private var userToDelete: String?

    // MARK: - Lifecycle

    init(githubAPIRepository: GithubAPIRepositoryProtocol,
         followerToDeleteRepository: FollowerToDeleteRepositoryInput) {
        self.githubAPIRepository = githubAPIRepository
        self.followerToDeleteRepository = followerToDeleteRepository
    }
}

// MARK: - FollowingListInteractorInput

extension FollowingListInteractor: FollowingListInteractorInput {
    func numberOfCategories() -> Int {
        return 1
    }
    
    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int {
        return self.followings.count
    }
    
    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> FollowingItemProtocol? {
        return followings[safe: index]
    }
    
    func retrieve() {
        output?.updateCategories([.add])
        output?.notifyLoading()

        self.githubAPIRepository.retrieveFollowings(success: { [weak self] usersResponse in
            DispatchQueue.global().async {
                self?.followings = usersResponse.compactMap {
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
                    
                    return FollowingItem(id: id, login: login, name: $0.name, company: $0.company, ownerAvatarData: ownerAvatarData)
                }
                DispatchQueue.main.async {
                    self?.output?.notifySuccess()
                    if (self?.followings.count == 0) {
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
    }

    func refresh() {
        retrieve()
    }

    func refreshAfterDelete() {
        DispatchQueue.global().async {
            if let index = self.followings.firstIndex(where: { $0.login == self.userToDelete }) {
                self.followings.remove(at: index)
                DispatchQueue.main.async {
                    self.output?.notifyDeletedFollower(at: Int(index), forCategoryIndex: 0)
                }
            }
        }
    }

    func prepareDelete(at index: Int, forCategoryIndex categoryIndex: Int) {
        guard let follower = followings[safe: index] else {
            output?.notifyInvalidFollowerError()
            return
        }
        followerToDeleteRepository.save(login: follower.login,
                                        success: { [weak self] in
                                            self?.userToDelete = follower.login
                                            self?.output?.notifyConfirmationDelete()
        }) { [weak self] _ in
            self?.output?.notifyUnknownError()
        }
    }
}

private struct FollowingItem: FollowingItemProtocol {
    var id: Int
    var login: String
    var name: String?
    var company: String?
    var ownerAvatarData: Data?
}

