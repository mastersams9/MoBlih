//
//  DeleteFollowerView.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class DeleteFollowerView: UIView, ViewLoadable {
    
    // MARK: - Property
    
    weak var delegate: DeleteFollowerViewDelegate?
    
    var presenter: DeleteFollowerPresenterInput!
    
    // MARK: - Publics
    
    func viewDidLoad() {
        presenter.viewDidLoad()
    }
}

// MARK: - DeleteFollowerPresenterOutput

extension DeleteFollowerView: DeleteFollowerPresenterOutput {
    
    func startLoader() {
        startLoading()
    }
    
    func stopLoader() {
        stopLoading()
    }
    
    func delegateSuccess() {
        delegate?.deleteFollowerViewDidFinishWithSuccess()
    }
    
    func delegateServerError(message: String) {
        delegate?.deleteFollowerViewDidTriggerServerError(message: message)
    }
    
    func delegateNetworkError(message: String) {
        delegate?.deleteFollowerViewDidTriggerNetworkError(message: message)
    }
}
