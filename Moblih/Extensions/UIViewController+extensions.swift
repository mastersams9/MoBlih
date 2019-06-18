//
//  UIViewController+extensions.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 10/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlertPopupWithTitle(_ title: String? = nil, message: String, confirmationTitle: String, cancelTitle: String? = nil, confirmHandler: (() -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var okAction = UIAlertAction(title: confirmationTitle, style: .default) { _ in
            confirmHandler?()
        }
        if let cancelTitle = cancelTitle {
            okAction = UIAlertAction(title: confirmationTitle, style: .destructive) { _ in
                confirmHandler?()
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
                cancelHandler?()
            }
            alertVC.addAction(cancelAction)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func presentAlertPopupWithTextfield(_ title: String,
                                    message: String,
                                    textFieldConfigurationHandler: ((UITextField) -> Void)? = nil,
                                    confirmationTitle: String, cancelTitle: String? = nil,
                                    confirmHandler: ((UIAlertController) -> Void)? = nil,
                                    cancelHandler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addTextField { textfield in
            textFieldConfigurationHandler?(textfield)
        }
        let okAction = UIAlertAction(title: confirmationTitle, style: .default) { _ in
            confirmHandler?(alertVC)
        }
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive) { _ in
                cancelHandler?()
            }
            alertVC.addAction(cancelAction)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}
