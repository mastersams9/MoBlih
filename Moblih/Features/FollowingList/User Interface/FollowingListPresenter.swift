//
//  FollowingListPresenter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

final class FollowingListPresenter {

    // MARK: - Property

    weak var output: FollowingListPresenterOutput?
    private var interactor: FollowingListInteractorInput
    private var router: FollowingListRouterInput

    // MARK: - Lifecycle

    init(interactor: FollowingListInteractorInput, router: FollowingListRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Converting

}

// MARK: - FollowersListPresenterInput

extension FollowingListPresenter: FollowingListPresenterInput {
    func numberOfSections() -> Int {
        return interactor.numberOfCategories()
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return interactor.numberOfItems(atCategoryIndex: section)
    }
    
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> FollowingListViewModelProtocol {
        let item = interactor.item(at: indexPath.row, forCategoryIndex: indexPath.section)
        
        var ownerImage = #imageLiteral(resourceName: "myProfile")
        
        if let ownerImageData = item?.ownerAvatarData, let ownerImageOpt = UIImage(data: ownerImageData) {
            ownerImage = ownerImageOpt
        }
        
        return FollowingListViewModel(name: item?.name ?? "No name", login: item?.login ?? "", image: ownerImage, company: item?.company ?? "No company")
        
    }
    
    func viewDidLoad() {
        interactor.retrieve()
    }

    func addFollowerViewDidFinishWithSuccess() {
        interactor.refresh()
    }

    func titleForDeleteConfirmationButtonForRowAt(_ indexPath: IndexPath) -> String {
        return "Unfollow"
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
}

// MARK: - FollowersListInteractorOutput

extension FollowingListPresenter: FollowingListInteractorOutput {
    func updateCategories(_ categories: [FollowingListCategory]) {
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
        output?.displayAlertPopupWithTitle("Empty list", message: "Oops! Seems like you don't follow other users", confirmationTitle: "OK")
        router.routeToMyProfile()
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
        router.routeToMyProfile()
    }
    
    func notifyNetworkError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Network Error", message: "Please check your connectivity.", confirmationTitle: "OK")
        router.routeToMyProfile()
    }

    func notifyInvalidFollowerError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Error", message: "Invalid Follower.", confirmationTitle: "OK")
    }

    func notifyConfirmationDelete() {
        output?.commitDelete()
    }

    func notifyUnknownError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Error", message: "Invalid Follower.", confirmationTitle: "OK")
    }

    func notifyDeletedFollower(at index: Int, forCategoryIndex categoryIndex: Int) {
        output?.deleteRowsAtIndexPaths([IndexPath(row: index,
                                                  section: categoryIndex)],
                                       with: .automatic)
    }
}

// MARK: - Privates

private struct FollowingListViewModel: FollowingListViewModelProtocol {
    var name: String
    var login: String
    var image: UIImage
    var company: String
}
