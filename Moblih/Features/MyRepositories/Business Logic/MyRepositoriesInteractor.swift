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
    private let githubAPIRepository: GithubAPIRepositoryProtocol
    private var repositories = [MyRepositoriesRepositoryItem]()
    private let repositoryInformationRepository: RepositoryInformationRepositoryProtocol

    // MARK: - Lifecycle

    init(githubAPIRepository: GithubAPIRepositoryProtocol,
         repositoryInformationRepository: RepositoryInformationRepositoryProtocol) {
        self.githubAPIRepository = githubAPIRepository
        self.repositoryInformationRepository = repositoryInformationRepository
    }
}

// MARK: - MyRepositoriesInteractorInput

extension MyRepositoriesInteractor: MyRepositoriesInteractorInput {

    func fetch() {
        output?.notifyLoading()

        githubAPIRepository.retrieveMyRepositories(success: { [weak self] repositoriesResponse in
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
        }) { [weak self] error in
            if case let githubAPIRepositoryError = error as GithubAPIRepositoryError,
                githubAPIRepositoryError == .network {
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
        guard let repository = repositories[safe: index] else { return }
        repositoryInformationRepository.save(owner: repository.ownerName, name: repository.name, success: { [weak self] in
            self?.output?.routeToRepositoryInformation()
        }, failure: nil)
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
