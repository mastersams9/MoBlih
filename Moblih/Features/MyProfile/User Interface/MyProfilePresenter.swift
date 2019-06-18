//
//  MyProfilePresenter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

final class MyProfilePresenter {

    // MARK: - Property

    weak var output: MyProfilePresenterOutput?
    private var interactor: MyProfileInteractorInput
    private var router: MyProfileRouterInput
    private let dateFormatter = DateFormatter()

    // MARK: - Lifecycle

    init(interactor: MyProfileInteractorInput, router: MyProfileRouterInput) {
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

// MARK: - MyProfilePresenterInput

extension MyProfilePresenter: MyProfilePresenterInput {

    func viewWillAppear() {
        interactor.prepare()
    }

    func refresherAttributedTitle() -> NSAttributedString {
        return NSAttributedString(string: "Loading...")
    }

    func refresherControlDidTriggerRefresh() {
        interactor.refresh()
    }

    func logoutViewIsRequesting() {
        interactor.prepareLogout()
    }

    func logoutViewDidFinish() {
        interactor.quit()
    }

    func titleForHeaderInSection(_ section: Int) -> String {
        return "Starred Repositories: "
    }

    func numberOfSections() -> Int {
        return interactor.numberOfCategories()
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return interactor.numberOfItems(atCategoryIndex: section)
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        interactor.prepareRepositoryInformation(at: indexPath.row, forCategoryIndex: indexPath.section)
    }
    
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> MyRepositoriesViewModelProtocol {
        
        let item = interactor.item(at: indexPath.row, forCategoryIndex: indexPath.section)
        
        var ownerImage = #imageLiteral(resourceName: "myProfile")
        
        if let ownerImageData = item?.ownerAvatarData, let ownerImageOpt = UIImage(data: ownerImageData) {
            ownerImage = ownerImageOpt
        }
        
        return MyProfileStarsViewModel(title: item?.name ?? "N/A",
                                       description: item?.description ?? "No Description",
                                       image: item?.isPrivate ?? false ? #imageLiteral(resourceName: "private") : #imageLiteral(resourceName: "public"),
                                       ownerName: item?.ownerName ?? "-",
                                       ownerImage: ownerImage,
                                       lastUpdated: formattedDateString(from: item?.lastUpdatedDate) ?? "N/A")
    }

    func myProfileDetailsViewDidTriggerNetworkError() {
        interactor.handleNetworkError(on: .myProfileDetails)
    }
    
    func myProfileDetailsFollowersButtonDidTouchUp() {
        interactor.prepareFollowersView()
    }
    
    func myProfileDetailsFollowingButtonDidTouchUp() {
        interactor.prepareFollowingView()
    }
}

// MARK: - MyProfileInteractorOutput

extension MyProfilePresenter: MyProfileInteractorOutput {
    func presentFollowingView() {
        router.routeToFollowingView()
    }
    
    func presentFollowersView() {
        router.routeToFollowersView()
    }
    
    
    func notifySuccess() {
        output?.stopLoader()
        output?.reloadData()
    }

    func notifyServerError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Server Error", message: "Oops! a server error occured when fetching starred repositories. Please try again later.", confirmationTitle: "OK")
    }
    
    func notifyNetworkError() {
        output?.stopLoader()
        output?.displayAlertPopupWithTitle("Network Error", message: "Please check your connectivity.", confirmationTitle: "OK")
    }
    
    func notifyLoading() {
        output?.startLoader()
    }

    func updateCategories(_ categories: [Category]) {
        output?.stopLoader()
        output?.displayViewCategories(categories.map {
            switch $0 {
            case .logout:
                return .logoutButtonItem
            case .myProfileDetails:
                return .myProfileDetails
            }
        })
    }

    func routeToAuthentication() {
        output?.stopLoader()
        router.routeToAuthentication()
    }
    
    func routeToRepositoryInformation() {
        router.routeToRepositoryInformations()
    }
}

// MARK: - Privates

private struct MyProfileStarsViewModel: MyRepositoriesViewModelProtocol {
    var title: String
    var description: String
    var image: UIImage
    var ownerName: String
    var ownerImage: UIImage
    var lastUpdated: String
}
