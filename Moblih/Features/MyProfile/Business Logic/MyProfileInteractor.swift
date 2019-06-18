//
//  MyProfileInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class MyProfileInteractor {

    // MARK: - Property

    private let oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol
    private let keychainWrapper: KeychainWrapperInput
    weak var output: MyProfileInteractorOutput?
    private let repositoryInformationRepository: RepositoryInformationRepositoryProtocol
    private var repositories: [MyProfileStarsItem] = []

    private var isNetworkErrorOccured = false

    // MARK: - Lifecycle

    init(oauthConfigurationWrapper: OAuthConfigurationWrapperProtocol,
         keychainWrapper: KeychainWrapperInput,
         repositoryInformationRepository: RepositoryInformationRepositoryProtocol) {
        self.oauthConfigurationWrapper = oauthConfigurationWrapper
        self.keychainWrapper = keychainWrapper
        self.repositoryInformationRepository = repositoryInformationRepository
    }

    private func handleNetworkError() {
        if !self.isNetworkErrorOccured {
            self.isNetworkErrorOccured = true
            self.output?.notifyNetworkError()
        }
    }

    private func retrieveMyStars() {

        isNetworkErrorOccured = false
        output?.notifyLoading()

        guard let accesstoken = try? self.keychainWrapper.findPassword() else {
            output?.notifyServerError()
            return
        }

        self.oauthConfigurationWrapper.retrieveMyStars(with: accesstoken, success: { [weak self] (starsResponse) in
            DispatchQueue.global().async {
                self?.repositories = starsResponse.compactMap {
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
                    return MyProfileStarsItem(id: id,
                                              name: name,
                                              description: $0.description,
                                              isPrivate: $0.isPrivate ?? false,
                                              ownerName: $0.owner?.login,
                                              ownerAvatarData: ownerAvatarData,
                                              lastUpdatedDate: $0.lastPush)
                }
                DispatchQueue.main.async {
                    self?.output?.notifySuccess()
                }
            }
            }, failure: { [weak self] error in
                guard let self = self else { return }
                if case let oauthConfigError = error as OAuthConfigurationWrapperError, oauthConfigError == .network {
                    self.handleNetworkError()
                    return
                }
                self.output?.notifyServerError()
        })
    }
}

// MARK: - MyProfileInteractorInput

extension MyProfileInteractor: MyProfileInteractorInput {
    func prepareFollowingView() {
        output?.presentFollowingView()
    }
    
    func prepareFollowersView() {
        output?.presentFollowersView()
    }
    

    func prepare() {
        output?.updateCategories([.logout, .myProfileDetails])
        retrieveMyStars()
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
    
    func prepareLogout() {
        output?.notifyLoading()
    }

    func quit() {
        output?.routeToAuthentication()
    }

    func handleNetworkError(on category: Category) {
        if category == .myProfileDetails { handleNetworkError() }
    }

    func refresh() {
        retrieveMyStars()
    }
    
    func prepareRepositoryInformation(at index: Int, forCategoryIndex categoryIndex: Int) {
        guard let repository = repositories[safe: index] else { return }
        repositoryInformationRepository.clear(success: nil, failure: nil)
        repositoryInformationRepository.save(owner: repository.ownerName, name: repository.name, success: nil, failure: nil)
        output?.routeToRepositoryInformation()
    }
}

private struct MyProfileStarsItem: MyRepositoriesRepositoryItemProtocol {
    var id: Int
    var name: String
    var description: String?
    var isPrivate: Bool
    var ownerName: String?
    var ownerAvatarData: Data?
    var lastUpdatedDate: Date?
}
