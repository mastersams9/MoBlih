//
//  RepositoryInfoPresenterOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol RepositoryInfoRepositoryViewModelProtocol {
    var name: String { get }
    var description: String { get }
    var repositoryPrivacyImage: UIImage { get }
    var ownerName: String { get }
    var ownerAvatarImage: UIImage { get }
    var lastUpdatedText: String { get }
    var starCountText: String { get }
}

protocol RepositoryInfoPresenterOutput: class {
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func displayRepositoryInformation(viewModel: RepositoryInfoRepositoryViewModelProtocol)
    func startLoader()
    func stopLoader()
}
