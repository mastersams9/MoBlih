//
//  LogoutView.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class LogoutView: UIView {

    // MARK: - Property

    weak var delegate: LogoutViewDelegate?

    var presenter: LogoutPresenterInput!

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Button Actions

    @IBAction func logoutButtonDidTouchUpInside(_ sender: UIButton) {
        presenter.logoutButtonDidTouchUpInside()
    }
}

// MARK: - LogoutPresenterOutput

extension LogoutView: LogoutPresenterOutput {

    func delegateLoading() {
        delegate?.logoutViewIsRequesting()
    }

    func delegateSuccess() {
        delegate?.logoutViewDidFinish()
    }
}
