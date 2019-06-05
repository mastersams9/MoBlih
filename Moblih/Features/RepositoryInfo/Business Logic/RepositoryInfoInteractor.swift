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
    private let id: Int
    private let oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol
    private let keychainWrapper: KeychainWrapperInput
    private var repositories = [RepositoryItem]()
    
    init(oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol,
         keychainWrapper: KeychainWrapperInput,
         id: Int) {
        self.oauthConfigurationWrapper = oauthConfigurationWrapper
        self.keychainWrapper = keychainWrapper
        self.id = id
    }

    // MARK: - Lifecycle
    
}

// MARK: - MyRepositoriesInteractorInput

extension RepositoryInfoInteractor: RepositoryInfoInteractorInput {
    func retrieve() {
        output?.notifyLoading()
        guard let accesstoken = try? self.keychainWrapper.findPassword() else {
            output?.notifyServerError()
            return
        }
        
        self.oauthConfigurationWrapper.retrieveMyRepositories(with: accesstoken, success: { [weak self] repositoriesResponse in
            DispatchQueue.global().async {
                self?.repositories = repositoriesResponse.compactMap {
                    // On supprime les repo qui n'ont pas de nom.
                    guard let name = $0.name else {
                        return nil
                    }
                    
                    guard let id =  $0.id else {
                        return nil
                    }
                    
                    var ownerAvatarData: Data? = nil
                    if let urlString = $0.owner?.avatarURL, let url = URL(string: urlString) {
                        ownerAvatarData = try? Data(contentsOf: url)
                    }
                    return RepositoryItem(id: id,
                                          name: name,
                                          description: $0.repositoryDescription,
                                          isPrivate: $0.isPrivate ?? false,
                                          ownerName: $0.owner?.login,
                                          ownerAvatarData: ownerAvatarData,
                                          lastUpdatedDate: $0.lastPush,
                                          starCount: 42)
                }
                DispatchQueue.main.async {
                    guard let repository = self?.repositories.filter({ $0.id == self?.id }).first else {
                        self?.output?.notifyNoDataError()
                        return
                    }
                    self?.output?.notifySuccess(repository: repository)
                }
            }
        }) { [weak self] error in
            if case let oauthConfigError = error as OAuthConfigurationWrapperError, oauthConfigError == .network {
                self?.output?.notifyNetworkError()
                return
            }
            self?.output?.notifyServerError()
        }
    }
}

private struct RepositoryItem: RepositoryInfoRepositoryItemProtocol {
    var id: Int
    var name: String
    var description: String?
    var isPrivate: Bool
    var ownerName: String?
    var ownerAvatarData: Data?
    var lastUpdatedDate: Date?
    var starCount: Int
}
