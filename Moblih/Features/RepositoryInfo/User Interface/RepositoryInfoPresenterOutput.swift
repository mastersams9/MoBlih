//
//  RepositoryInfoPresenterOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol RepositoryInfoRepositoryViewModelProtocol {
    var title: String { get }
    var descriptionText: String { get }
    var description: String { get }
    var repositoryPrivacyImage: UIImage { get }
    var ownerText: String { get }
    var ownerName: String { get }
    var ownerAvatarImage: UIImage { get }
    var lastUpdatedText: String { get }
    var lastUpdated: String { get }
    var starsCountText: String { get }
    var starsCount: String { get }
    var watchersCountText: String { get }
    var watchersCount: String { get }
    var defaultBranchText: String { get }
    var defaultBranch: String { get }
}

protocol RepositoryInfoPresenterOutput: class {
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func displayRepositoryInformation(viewModel: RepositoryInfoRepositoryViewModelProtocol)
    func startLoader()
    func stopLoader()
    func updateManageCollaboratorsButtonVisibility(_ isVisible: Bool)
}
