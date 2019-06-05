//
//  MyRepositoriesInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class MyRepositoriesInteractor {
    // MARK: - Property

    weak var output: MyRepositoriesInteractorOutput?
    private let oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol
    private let keychainWrapper: KeychainWrapperInput
    private var repositories = [MyRepositoriesRepositoryItem]()

    // MARK: - Lifecycle

    init(oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol, keychainWrapper: KeychainWrapperInput) {
        self.oauthConfigurationWrapper = oauthConfigurationWrapper
        self.keychainWrapper = keychainWrapper
    }
}

// MARK: - MyRepositoriesInteractorInput

extension MyRepositoriesInteractor: MyRepositoriesInteractorInput {

    func fetch() {
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
                    return MyRepositoriesRepositoryItem(id: id,
                                                        name: name,
                                                        description: $0.repositoryDescription,
                                                        isPrivate: $0.isPrivate ?? false,
                                                        ownerName: $0.owner?.login,
                                                        ownerAvatarData: ownerAvatarData,
                                                        lastUpdatedDate: $0.lastPush)
                }
                DispatchQueue.main.async {
                    self?.output?.notifySuccess()
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

    func refresh() {
        fetch()
    }
    
    func numberOfCategories() -> Int {
        return 1
    }

    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int {
        return repositories.count
    }

    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> MyRepositoriesRepositoryItemProtocol? {
        return repositories[safe: index]
    }

    func prepareAddRepository() {
        output?.routeToAddingRepository()
    }
    
    func prepareRepositoryInformation(at index: Int, forCategoryIndex categoryIndex: Int) {
        guard let id = repositories[safe: index]?.id else { return }
        output?.routeToRepositoryInformation(with: id)
    }
}

// MARK: - Privates

private struct MyRepositoriesRepositoryItem: MyRepositoriesRepositoryItemProtocol {
    var id: Int
    var name: String
    var description: String?
    var isPrivate: Bool
    var ownerName: String?
    var ownerAvatarData: Data?
    var lastUpdatedDate: Date?
}
