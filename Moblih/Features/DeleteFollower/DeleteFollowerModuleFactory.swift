//
//  DeleteFollowerModuleFactory.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol DeleteFollowerModuleFactoryProtocol {
    var delegate: DeleteFollowerViewDelegate? { get set }
    func makeView() -> DeleteFollowerView?
}

class DeleteFollowerModuleFactory: DeleteFollowerModuleFactoryProtocol {

    var delegate: DeleteFollowerViewDelegate? {
        didSet {
            view?.delegate = delegate
        }
    }

    private let view = UINib(nibName: "DeleteFollowerView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? DeleteFollowerView

    func makeView() -> DeleteFollowerView? {
        let keychainWrapper = KeychainWrapper()
        let moblihAPI = MoblihAPI()
        let githubAPIRepository = GithubAPIRepository(api: moblihAPI,
                                                      keychainWrapper: keychainWrapper)
        let interactor = DeleteFollowerInteractor(githubAPIRepository: githubAPIRepository,
                                                  followerToDeleteRepository: FollowerToDeleteRepository.shared)

        let presenter = DeleteFollowerPresenter(interactor: interactor)
        interactor.output = presenter

        view?.presenter = presenter
        presenter.output = view

        return view
    }
}
