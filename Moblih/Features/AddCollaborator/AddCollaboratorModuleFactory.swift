//
//  AddCollaboratorModuleFactory.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol AddCollaboratorModuleFactoryProtocol {
    var delegate: (UIViewController & AddCollaboratorViewDelegate)? { get set }
    func makeView(parentViewController: UIViewController) -> AddCollaboratorView?
}

class AddCollaboratorModuleFactory: AddCollaboratorModuleFactoryProtocol {
    
    var delegate: (UIViewController & AddCollaboratorViewDelegate)? {
        didSet {
            view?.delegate = delegate
        }
    }
    
    private let view = UINib(nibName: "AddCollaboratorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? AddCollaboratorView
    
    func makeView(parentViewController: UIViewController) -> AddCollaboratorView? {
        let interactor = AddCollaboratorInteractor()
        let router = AddCollaboratorRouter()
        let presenter = AddCollaboratorPresenter(interactor: interactor,
                                                 router: router)
        interactor.output = presenter
        router.parentViewController = parentViewController
        view?.presenter = presenter
        presenter.output = view
        
        return view
    }
}
