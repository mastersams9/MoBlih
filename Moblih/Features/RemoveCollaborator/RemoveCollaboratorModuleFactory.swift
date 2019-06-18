//
//  RemoveCollaboratorModuleFactory.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol RemoveCollaboratorModuleFactoryProtocol {
    var delegate: RemoveCollaboratorViewDelegate? { get set }
    func makeView() -> RemoveCollaboratorView?
}

class RemoveCollaboratorModuleFactory: RemoveCollaboratorModuleFactoryProtocol {
    
    var delegate: RemoveCollaboratorViewDelegate? {
        didSet {
            view?.delegate = delegate
        }
    }
    
    private let view = UINib(nibName: "RemoveCollaboratorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? RemoveCollaboratorView
    
    func makeView() -> RemoveCollaboratorView? {
        
        let keychainWrapper = KeychainWrapper()
        let moblihAPI = MoblihAPI()
        let githubAPIRepository = GithubAPIRepository(api: moblihAPI,
                                                      keychainWrapper: keychainWrapper)
        
        
        let interactor = RemoveCollaboratorInteractor(githubAPIRepository: githubAPIRepository,
                                                      collaboratorToDeleteRepository: CollaboratorToDeleteRepository.shared,
                                                      repositoryInformationRepository: RepositoryInformationRepository.shared)
        let presenter = RemoveCollaboratorPresenter(interactor: interactor)
        interactor.output = presenter
        
        view?.presenter = presenter
        presenter.output = view
        
        return view
    }
}
