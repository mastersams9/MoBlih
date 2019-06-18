//
//  AddRepositoryInteractor.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class AddRepositoryInteractor {

    // MARK: - Property

    weak var output: AddRepositoryInteractorOutput?

    private let githubAPIRepository: GithubAPIRepositoryProtocol
    private let keychainWrapper: KeychainWrapperInput
    
    private var isPrivate: Bool = false
    private var addReadme: Bool = true
    private var name = ""
    private var description = ""
    private var isNameAlreadyExist = false

    // MARK: - Lifecycle

    init(githubAPIRepository: GithubAPIRepositoryProtocol,
         keychainWrapper: KeychainWrapperInput) {
        self.githubAPIRepository = githubAPIRepository
        self.keychainWrapper = keychainWrapper
    }
    
    private func updatePrivateEnability() {
        if isPrivate {
            output?.enablePrivate()
            return
        }
        output?.disablePrivate()
    }

    private func updateAddReadmeEnability() {
        if addReadme {
            output?.enableAddReadme()
            return
        }
        output?.disableAddReadme()
    }

    private func updateName() {
        output?.updateName(name)
        if isNameAlreadyExist {
            output?.notifyRepositoryAlreadyExistsError()
            return
        }
    }
}

// MARK: - AddRepositoryInteractorInput

extension AddRepositoryInteractor: AddRepositoryInteractorInput {
    
    func retrieve() {
        output?.setDefaultValues()
        updatePrivateEnability()
        updateAddReadmeEnability()
    }
    
    func updateNameText(text: String) {
        isNameAlreadyExist = false
        name = text
    }
    
    func updateDescriptionText(text: String) {
        description = text
        updateName()
    }
    
    func updateAddReadmeValue(value: Bool) {
        addReadme = value
        updateName()
        updateAddReadmeEnability()
    }
    
    func updateIsPrivateValue(value: Bool) {
        isPrivate = value
        updateName()
        updatePrivateEnability()
    }
    
    func create() {
        isNameAlreadyExist = false
        output?.notifyLoading()
        updateName()
        if name.isEmpty {
            output?.notifyEmptyNameError()
            return
        }
        
        let githubAPIRepositoryCreationRequest = GithubAPIRepositoryCreationRequest(
            name: name,
            description:description,
            isPrivate: isPrivate,
            isReadmeAutoInit: addReadme)
        
        githubAPIRepository.repositoryCreation(from: githubAPIRepositoryCreationRequest,
                                               success: { [weak self] in
                                                self?.output?.notifyCreationSuccess()
                                                self?.output?.routeToMyRepositories()
                                                
        }) { [weak self] (error) in
            switch error {
            case .network:
                self?.output?.notifyNetworkError()
            case .noData:
                self?.output?.notifyNoData()
            case .unknown:
                self?.isNameAlreadyExist = true
                self?.output?.notifyRepositoryAlreadyExistsError()
            default:
                self?.output?.notifyServerError()
            }
        }
    }
}

// MARK: - Privates

private struct GithubAPIRepositoryCreationRequest: GithubAPIRepositoryCreationRequestProtocol {
    var name: String
    var description: String?
    var isPrivate: Bool
    var isReadmeAutoInit: Bool
}
