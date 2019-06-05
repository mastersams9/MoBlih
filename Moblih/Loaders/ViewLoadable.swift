//
//  ViewLoadable.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol ViewLoadable: UIView {

    func startLoading()
    func stopLoading()
}

extension ViewLoadable {

    func startLoading() {
        if let loadingView = UINib(nibName: "LoadableView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView {
            loadingView.tag = 10003
            loadingView.prepareForAutoLayout()
            addSubview(loadingView)
            loadingView.constraintToView(self)
        }
    }

    func stopLoading() {
        let viewToRemove = viewWithTag(10003)
        viewToRemove?.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations: {
            viewToRemove?.alpha = 0.0
        }) { _ in
            viewToRemove?.removeFromSuperview()
        }
    }
}
