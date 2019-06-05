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
}

// MARK: - FollowersListInteractorOutput

extension FollowingListPresenter: FollowingListInteractorOutput {
    
    func notifyEmptyList() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Empty list", message: "Oops! Seems like you don't follow other users", confirmationTitle: "OK")
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
    }
    
    func notifyNetworkError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Network Error", message: "Please check your connectivity.", confirmationTitle: "OK")
    }
    
}

// MARK: - Privates

private struct FollowingListViewModel: FollowingListViewModelProtocol {
    var name: String
    
    var login: String
    
    var image: UIImage
    
    var company: String
}
