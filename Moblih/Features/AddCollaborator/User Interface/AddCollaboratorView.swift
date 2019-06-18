//
//  AddCollaboratorView.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AddCollaboratorView: UIView {
    
    // MARK: - Property
    
    weak var delegate: AddCollaboratorViewDelegate?
    
    var presenter: AddCollaboratorPresenterInput!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - IBAction
    
    @IBAction func addButtonDidTouchUpInside(_ sender: UIButton) {
        presenter.addButtonDidTouchUpInside()
    }
    
    
}

// MARK: - AddCollaboratorPresenterOutput

extension AddCollaboratorView: AddCollaboratorPresenterOutput {
    func delegateLoading() {
        delegate?.addCollaboratorViewIsRequesting()
    }
    
    func delegateSuccess() {
        delegate?.addCollaboratorViewDidFinishWithSuccess()
    }
}
