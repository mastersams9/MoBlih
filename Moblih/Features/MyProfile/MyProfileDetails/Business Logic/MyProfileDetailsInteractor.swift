//
//  MyProfileDetailsInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class MyProfileDetailsInteractor {
    
    // MARK: - Property
    
    weak var output: MyProfileDetailsInteractorOutput?
    
    private var user: MyProfileDetailsItem?
    private let githubAPIRepository: GithubAPIRepositoryProtocol
    
    // MARK: - Lifecycle
    
    init(githubAPIRepository: GithubAPIRepositoryProtocol) {
        self.githubAPIRepository = githubAPIRepository
    }
}

// MARK: - MyProfileDetailsInteractorInput

extension MyProfileDetailsInteractor: MyProfileDetailsInteractorInput {
    func prepareFollowing() {
        output?.routeToFollowing()
    }
    
    func prepareFollowers() {
        output?.routeToFollowers()
    }
    
    
    func retrieve() {
        
        output?.notifyLoading()
        
        self.githubAPIRepository.retrieveUserInformations(success: {[weak self] (userResponse) in
            guard let self = self else { return }
            guard let id = userResponse.id, let login = userResponse.login else {
                self.output?.notifyServerError()
                return
            }
            
            DispatchQueue.global().async {
                var ownerAvatarData: Data? = nil
                if let urlString = userResponse.avatarURL, let url = URL(string: urlString) {
                    ownerAvatarData = try? Data(contentsOf: url)
                }
                
                let numberOfRepos = (userResponse.numberOfPublicRepos ?? 0) + (userResponse.numberOfPrivateRepos ?? 0)
                let user = MyProfileDetailsItem(id: id,
                                                login: login,
                                                name: userResponse.name,
                                                company: userResponse.company,
                                                numberOfRepos: numberOfRepos,
                                                ownerAvatarData: ownerAvatarData,
                                                followings: userResponse.followings ?? 0,
                                                followers: userResponse.followers ?? 0)
                self.user = user
                DispatchQueue.main.async {
                    self.output?.loadUserProfile(user)
                }
                
            }
        }) { [weak self] (error) in
            switch error {
            case .network:
                self?.output?.notifyNetworkError()
            default:
                self?.output?.notifyServerError()
            }
        }
    }
    
    func refresh() {
        retrieve()
    }
}

// MARK: - Privates

private struct MyProfileDetailsItem: MyProfileDetailsItemProtocol {
    var id: Int
    var login: String
    var name: String?
    var company: String?
    var numberOfRepos: Int
    var ownerAvatarData: Data?
    var followings: Int
    var followers: Int
}

