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
    private var interactor: RepositoryInfoInteractorInput
    private let dateFormatter = DateFormatter()
    
    // MARK: - Lifecycle
    
    init(interactor: RepositoryInfoInteractorInput) {
        self.interactor = interactor
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
        
        let starCount = "\(repository.starCount) " + (repository.starCount > 9 ? "stars": "star")
        
        var ownerAvatarImage = #imageLiteral(resourceName: "myProfile")
        
        if let data = repository.ownerAvatarData, let image = UIImage(data: data) {
            ownerAvatarImage = image
        }
        
        
        
        let lastUpdatedText = formattedDateString(from: repository.lastUpdatedDate) ?? "N/A"
        
        let viewModel = RepositoryInfoRepositoryViewModel(name: repository.name,
                                                          description: repository.description ?? "No description",
                                                          repositoryPrivacyImage: repositoryPrivacyImage,
                                                          ownerName: repository.ownerName ?? "-",
                                                          ownerAvatarImage: ownerAvatarImage,
                                                          lastUpdatedText: lastUpdatedText,
                                                          starCountText: starCount)
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
}

private struct RepositoryInfoRepositoryViewModel: RepositoryInfoRepositoryViewModelProtocol {
    var name: String
    var description: String
    var repositoryPrivacyImage: UIImage
    var ownerName: String
    var ownerAvatarImage: UIImage
    var lastUpdatedText: String
    var starCountText: String
}
