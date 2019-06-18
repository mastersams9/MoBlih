//
//  AddFollowerModuleFactory.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol AddFollowerModuleFactoryProtocol {
    var delegate: (UIViewController & AddFollowerViewDelegate)? { get set }
    func makeView(parentViewController: UIViewController) -> AddFollowerView?
}

class AddFollowerModuleFactory: AddFollowerModuleFactoryProtocol {

    weak var delegate: (UIViewController & AddFollowerViewDelegate)? {
        didSet {
            view?.delegate = delegate
        }
    }

    private var view = UINib(nibName: "AddFollowerView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? AddFollowerView


    func makeView(parentViewController: UIViewController) -> AddFollowerView? {
        let keychainWrapper = KeychainWrapper()
        let githubAPIRepository = GithubAPIRepository(api: MoblihAPI(),
                                                      keychainWrapper: keychainWrapper)

        let interactor = AddFollowerInteractor(githubAPIRepository: githubAPIRepository)
        let presenter = AddFollowerPresenter(interactor: interactor)
        interactor.output = presenter

        view?.parentViewController = parentViewController
        view?.presenter = presenter
        presenter.output = view
        
        return view
  }
}
