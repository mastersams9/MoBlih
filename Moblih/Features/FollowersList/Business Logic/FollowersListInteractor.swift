//
//  FollowersListInteractor.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class FollowersListInteractor {
    // MARK: - Property
    
    weak var output: FollowersListInteractorOutput?
    private var githubAPIRepository: GithubAPIRepositoryProtocol
    private var followers: [FollowersItemProtocol] = []
    
    // MARK: - Lifecycle
    
    init(githubAPIRepository: GithubAPIRepositoryProtocol) {
        self.githubAPIRepository = githubAPIRepository
    }
}

// MARK: - FollowersListInteractorInput

extension FollowersListInteractor: FollowersListInteractorInput {
    func numberOfCategories() -> Int {
        return 1
    }
    
    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int {
        return self.followers.count
    }
    
    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> FollowersItemProtocol? {
        return followers[safe: index]
    }



    func retrieve() {
        output?.notifyLoading()
        
        self.githubAPIRepository.retrieveFollowers(success: { [weak self] usersResponse in
            DispatchQueue.global().async {
                self?.followers = usersResponse.compactMap {
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
                    
                    return FollowersItem(id: id, login: login, name: $0.name, company: $0.company, ownerAvatarData: ownerAvatarData)
                }
                DispatchQueue.main.async {
                    self?.output?.notifySuccess()
                    if self?.followers.count == 0 {
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
}

private struct FollowersItem: FollowersItemProtocol {
    var id: Int
    var login: String
    var name: String?
    var company: String?
    var ownerAvatarData: Data?
}
