//
//  RepositoryInfoPresenter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

final class RepositoryInfoPresenter {
    
    // MARK: - Property
    
    weak var output: RepositoryInfoPresenterOutput?
    private let interactor: RepositoryInfoInteractorInput
    private let router: RepositoryInfoRouterInput
    private let dateFormatter = DateFormatter()
    
    // MARK: - Lifecycle
    
    init(interactor: RepositoryInfoInteractorInput,
         router: RepositoryInfoRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Converting
    
    private func formattedDateString(from date: Date?) -> String? {
        guard let date = date else { return nil }
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}

// MARK: - MyRepositoriesPresenterInput

extension RepositoryInfoPresenter: RepositoryInfoPresenterInput {
    
    func viewDidLoad() {
        interactor.retrieve()
    }
    
    func refresherAttributedTitle() -> NSAttributedString {
        return NSAttributedString(string: "Loading...")
    }
    
    func refresherControlDidTriggerRefresh() {
        interactor.refresh()
    }

    func manageCollaboratorsDidTouchUpInside() {
        interactor.prepareManageCollaborators()
    }
}

// MARK: - MyRepositoriesInteractorOutput

extension RepositoryInfoPresenter: RepositoryInfoInteractorOutput {
    func notifyLoading() {
        output?.startLoader()
    }
    
    func notifyNoDataError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Unkown repository", message: "Impossible to get this repository details", confirmationTitle: "OK")
    }
    
    func notifySuccess(repository: RepositoryInfoRepositoryItemProtocol) {
        let repositoryPrivacyImage = repository.isPrivate ? #imageLiteral(resourceName: "private") : #imageLiteral(resourceName: "public")

        var ownerAvatarImage = #imageLiteral(resourceName: "myProfile")
        
        if let data = repository.ownerAvatarData, let image = UIImage(data: data) {
            ownerAvatarImage = image
        }
        
        
        
        let lastUpdated = formattedDateString(from: repository.lastUpdatedDate) ?? "N/A"
        
        let viewModel = RepositoryInfoRepositoryViewModel(title: repository.name,
                                                          descriptionText: "Description:",
                                                          description: repository.description ?? "No description",
                                                          repositoryPrivacyImage: repositoryPrivacyImage,
                                                          ownerText: "Owner:",
                                                          ownerName: repository.ownerName ?? "-",
                                                          ownerAvatarImage: ownerAvatarImage,
                                                          lastUpdatedText: "📮 Last Updated:",
                                                          lastUpdated: lastUpdated,
                                                          starsCountText: "⭐️ Stars:",
                                                          starsCount: "\(repository.starCount)",
                                                          watchersCountText: "👀 Watchers:",
                                                          watchersCount: "\(repository.watchersCount)",
                                                          defaultBranchText: "🏡 Default Branch:",
                                                          defaultBranch: "\(repository.defaultBranch ?? "N/A")")
        output?.stopLoader()
        output?.displayRepositoryInformation(viewModel: viewModel)
    }
    
    func notifyServerError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Server Error", message: "Oops! a server error occured. Please try again later.", confirmationTitle: "OK")
    }
    
    func notifyNetworkError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Network Error", message: "Please check your connectivity.", confirmationTitle: "OK")
    }

    func routeToManageCollaborators() {
        router.routeToManageCollaborators()
    }

    func enableManageCollaboratorsEdition() {
        output?.updateManageCollaboratorsButtonVisibility(true)
    }
    
    func disableManageCollaboratorsEdition() {
        output?.updateManageCollaboratorsButtonVisibility(false)
    }
}

private struct RepositoryInfoRepositoryViewModel: RepositoryInfoRepositoryViewModelProtocol {
    var title: String
    var descriptionText: String
    var description: String
    var repositoryPrivacyImage: UIImage
    var ownerText: String
    var ownerName: String
    var ownerAvatarImage: UIImage
    var lastUpdatedText: String
    var lastUpdated: String
    var starsCountText: String
    var starsCount: String
    var watchersCountText: String
    var watchersCount: String
    var defaultBranchText: String
    var defaultBranch: String
}
