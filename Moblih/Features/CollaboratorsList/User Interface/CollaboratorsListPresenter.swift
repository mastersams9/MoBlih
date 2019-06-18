//
//  CollaboratorsListPresenter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

final class CollaboratorsListPresenter {
    
    // MARK: - Property
    
    weak var output: CollaboratorsListPresenterOutput?
    private var interactor: CollaboratorsListInteractorInput
    private var router: CollaboratorsListRouterInput
    
    // MARK: - Lifecycle
    
    init(interactor: CollaboratorsListInteractorInput, router: CollaboratorsListRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Converting
    
}

// MARK: - CollaboratorsListPresenterInput

extension CollaboratorsListPresenter: CollaboratorsListPresenterInput {
    
    var title: String {
        return "Manage Collaborators"
    }
    
    func viewWillAppear() {
        interactor.retrieve()
    }
    
    func numberOfSections() -> Int {
        return interactor.numberOfCategories()
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return interactor.numberOfItems(atCategoryIndex: section)
    }
    
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> CollaboratorsListViewModelProtocol {
        let item = interactor.item(at: indexPath.row, forCategoryIndex: indexPath.section)
        
        var ownerImage = #imageLiteral(resourceName: "myProfile")
        
        if let ownerImageData = item?.ownerAvatarData, let ownerImageOpt = UIImage(data: ownerImageData) {
            ownerImage = ownerImageOpt
        }
        
        var permission = "Permissions: "
        switch item?.permission {
        case .admin?:
            permission.append("Admin")
        case .push?:
            permission.append("Push and Pull")
        case .pull?:
            permission.append("Pull")
        default:
            permission.append("N/A")
        }
        
        return CollaboratorsListViewModel(login: item?.login ?? "N/A",
                                          image: ownerImage,
                                          permission: permission)
    }
    
    func refresherAttributedTitle() -> NSAttributedString {
        return NSAttributedString(string: "Loading...")
    }
    
    func refresherControlDidTriggerRefresh() {
        interactor.refresh()
    }
    
    func tableViewCommit(_ editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            interactor.prepareDelete(at: indexPath.row,
                                     forCategoryIndex: indexPath.section)
        }
    }
    
    func deleteFollowerViewDidFinishWithSuccess() {
        interactor.refreshAfterDelete()
    }
    
    func addCollaboratorViewDidFinishWithSuccess() {
        interactor.refresh()
    }
}

// MARK: - CollaboratorsListInteractorOutput

extension CollaboratorsListPresenter: CollaboratorsListInteractorOutput {
    
    func updateCategories(_ categories: [CollaboratorsListCategory]) {
        output?.stopLoader()
        output?.displayViewCategories(categories.map {
            switch $0 {
            case .add:
                return .addButtonItem
            }
        })
    }
    
    func notifyEmptyList() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Empty list", message: "Oops! Seems like you have no followers", confirmationTitle: "OK")
        router.routeToRepositoryInfo()
    }
    
    func notifyLoading() {
        output?.startLoader()
    }
    
    func notifySuccess() {
        output?.stopLoader()
        output?.reloadData()
    }
    
    func notifyServerError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Server Error", message: "Oops! a server error occured. Please try again later.", confirmationTitle: "OK")
        router.routeToRepositoryInfo()
    }
    
    func notifyInvalidCollaboratorError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Error", message: "Invalid Collaborator.", confirmationTitle: "OK")
    }
    
    func notifyNetworkError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Network Error", message: "Please check your connectivity.", confirmationTitle: "OK")
        router.routeToRepositoryInfo()
    }
    
    func notifyConfirmationDelete() {
        output?.commitDelete()
    }
    
    func notifyUnknownError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Error", message: "Invalid Collaborator.", confirmationTitle: "OK")
    }
    
    func notifyDeletedCollaborator(at index: Int, forCategoryIndex categoryIndex: Int) {
        output?.deleteRowsAtIndexPaths([IndexPath(row: index,
                                                  section: categoryIndex)],
                                       with: .automatic)
    }
}

// MARK: - Privates

private struct CollaboratorsListViewModel: CollaboratorsListViewModelProtocol {
    var login: String
    var image: UIImage
    var permission: String
}
