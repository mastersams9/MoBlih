//
//  Loadable.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol Loadable: UIViewController {

    func startLoading()
    func stopLoading()
}

extension Loadable {

    func startLoading() {
        if let loadingView = UINib(nibName: "LoadableView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView {
            loadingView.tag = 10001
            loadingView.prepareForAutoLayout()
            UIApplication.shared.keyWindow?.addSubview(loadingView)
            loadingView.constraintToView(UIApplication.shared.keyWindow!)
        }
    }

    func stopLoading() {
        let viewToRemove = UIApplication.shared.keyWindow?.viewWithTag(10001)
        viewToRemove?.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations: {
            viewToRemove?.alpha = 0.0
        }) { _ in
            viewToRemove?.removeFromSuperview()
        }
    }
}
