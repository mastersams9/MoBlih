//
//  MyProfileDetailsModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol MyProfileDetailsModuleFactoryProtocol {
    var delegate: MyProfileDetailsViewDelegate? { get set }
    func makeView() -> MyProfileDetailsView?
}

class MyProfileDetailsModuleFactory: MyProfileDetailsModuleFactoryProtocol {

    weak var delegate: MyProfileDetailsViewDelegate?

    func makeView() -> MyProfileDetailsView? {
        let keychainWrapper = KeychainWrapper()
        let moblihAPI = MoblihAPI()
        let githubAPIRepository = GithubAPIRepository(api: moblihAPI,
                                                      keychainWrapper: keychainWrapper)

        let interactor = MyProfileDetailsInteractor(githubAPIRepository: githubAPIRepository)
        let presenter = MyProfileDetailsPresenter(interactor: interactor)
        interactor.output = presenter

        let view = UINib(nibName: "MyProfileDetailsView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? MyProfileDetailsView
        view?.presenter = presenter
        view?.delegate = delegate
        presenter.output = view
        
        return view
    }
}
