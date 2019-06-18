//
//  LogoutModuleFactory.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol LogoutModuleFactoryProtocol {
    var delegate: (UIViewController & LogoutViewDelegate)? { get set }
    func makeView() -> LogoutView?
}

class LogoutModuleFactory: LogoutModuleFactoryProtocol {

    weak var delegate: (UIViewController & LogoutViewDelegate)? {
        didSet {
            view?.delegate = delegate
        }
    }
    
    private let view = UINib(nibName: "LogoutView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LogoutView
    
    func makeView() -> LogoutView? {
        let interactor = LogoutInteractor(keychainWrapper: KeychainWrapper())
        let presenter = LogoutPresenter(interactor: interactor)
        
        interactor.output = presenter
        view?.presenter = presenter
        presenter.output = view

        return view
    }
}
