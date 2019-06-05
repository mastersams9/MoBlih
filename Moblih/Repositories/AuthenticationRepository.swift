//
//  AuthenticationRepository.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit
import SafariServices

protocol AuthenticationRepositoryInput {
    func load(_ url: URL?)
    func quit(completion: @escaping () -> Void)
}

protocol AuthenticationRepositoryOutput: class {
    func didReceiveBadUrlError()
    func didFinish()
}

extension AuthenticationRepositoryOutput {

    func didReceiveBadUrlError() {}
    func didFinish() {}
}

class AuthenticationRepository: NSObject, AuthenticationRepositoryInput {
    
    private let viewController: UIViewController?
    weak var output: AuthenticationRepositoryOutput?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func load(_ url: URL?) {
        guard let url = url else {
            output?.didReceiveBadUrlError()
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.delegate = self
        viewController?.present(vc,
                                animated: true)
    }

    func quit(completion: @escaping () -> Void) {
        viewController?.dismiss(animated: true,
                                completion: completion)
    }
}

// MARK: - SFSafariViewControllerDelegate

extension AuthenticationRepository: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        output?.didFinish()
    }
}
