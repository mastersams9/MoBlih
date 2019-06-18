//
//  RemoveCollaboratorView.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class RemoveCollaboratorView: UIView, ViewLoadable {
    
    // MARK: - Property
    
    weak var delegate: RemoveCollaboratorViewDelegate?
    
    var presenter: RemoveCollaboratorPresenterInput!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public
    
    func viewDidLoad() {
        presenter.viewDidLoad()
    }
}

// MARK: - RemoveCollaboratorPresenterOutput

extension RemoveCollaboratorView: RemoveCollaboratorPresenterOutput {
    func startLoader() {
        startLoading()
    }
    
    func stopLoader() {
        stopLoading()
    }
    
    func delegateSuccess() {
        delegate?.removeCollaboratorViewDidFinishWithSuccess()
    }
    
    func delegateServerError(message: String) {
        delegate?.removeCollaboratorViewDidTriggerServerError(message: message)
    }
    
    func delegateNetworkError(message: String) {
        delegate?.removeCollaboratorViewDidTriggerNetworkError(message: message)
    }
}
