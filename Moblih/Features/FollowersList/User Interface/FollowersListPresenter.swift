//
//  followersListPresenter.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

final class FollowersListPresenter {

  // MARK: - Property

  weak var output: FollowersListPresenterOutput?
  private var interactor: FollowersListInteractorInput
    private var router: FollowersListRouterInput

  // MARK: - Lifecycle

    init(interactor: FollowersListInteractorInput, router: FollowersListRouterInput) {
      self.interactor = interactor
        self.router = router
  }

  // MARK: - Converting

}

// MARK: - FollowersListPresenterInput

extension FollowersListPresenter: FollowersListPresenterInput {
    func numberOfSections() -> Int {
        return interactor.numberOfCategories()
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return interactor.numberOfItems(atCategoryIndex: section)
    }
    
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> FollowersListViewModelProtocol {
        let item = interactor.item(at: indexPath.row, forCategoryIndex: indexPath.section)
        
        var ownerImage = #imageLiteral(resourceName: "myProfile")
        
        if let ownerImageData = item?.ownerAvatarData, let ownerImageOpt = UIImage(data: ownerImageData) {
            ownerImage = ownerImageOpt
        }
        
        return FollowersListViewModel(name: item?.name ?? "No name", login: item?.login ?? "", image: ownerImage, company: item?.company ?? "No company")

    }
    
  func viewDidLoad() {
  interactor.retrieve()
  }
}

// MARK: - FollowersListInteractorOutput

extension FollowersListPresenter: FollowersListInteractorOutput {
    func notifyEmptyList() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Empty list", message: "Oops! Seems like you have no followers", confirmationTitle: "OK")
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

private struct FollowersListViewModel: FollowersListViewModelProtocol {
    var name: String
    
    var login: String
    
    var image: UIImage
    
    var company: String
}
