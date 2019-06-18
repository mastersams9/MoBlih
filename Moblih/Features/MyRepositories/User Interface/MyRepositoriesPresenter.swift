//
//  MyRepositoriesPresenter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

final class MyRepositoriesPresenter {

    // MARK: - Property

    weak var output: MyRepositoriesPresenterOutput?
    private var interactor: MyRepositoriesInteractorInput
    private var router: MyRepositoriesRouterInput
    private let dateFormatter = DateFormatter()

    // MARK: - Lifecycle

    init(interactor: MyRepositoriesInteractorInput, router: MyRepositoriesRouterInput) {
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

extension MyRepositoriesPresenter: MyRepositoriesPresenterInput {

    func viewDidLoad() {
        interactor.fetch()
    }
    
    func refresherAttributedTitle() -> NSAttributedString {
        return NSAttributedString(string: "Loading...")
    }

    func addRepositoryTableViewControllerDidFinish() {
        interactor.refresh()
    }
    
    func refresherControlDidTriggerRefresh() {
        interactor.refresh()
    }

    func numberOfSections() -> Int {
        return interactor.numberOfCategories()
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        return interactor.numberOfItems(atCategoryIndex: section)
    }

    func viewModelAtIndexPath(_ indexPath: IndexPath) -> MyRepositoriesViewModelProtocol {
        
        let item = interactor.item(at: indexPath.row, forCategoryIndex: indexPath.section)

        var ownerImage = #imageLiteral(resourceName: "myProfile")

        if let ownerImageData = item?.ownerAvatarData, let ownerImageOpt = UIImage(data: ownerImageData) {
            ownerImage = ownerImageOpt
        }

        return MyRepositoriesViewModel(title: item?.name ?? "N/A",
                                       description: item?.description ?? "No Description",
                                       image: item?.isPrivate ?? false ? #imageLiteral(resourceName: "private") : #imageLiteral(resourceName: "public"),
                                       ownerName: item?.ownerName ?? "-",
                                       ownerImage: ownerImage,
                                       lastUpdated: formattedDateString(from: item?.lastUpdatedDate) ?? "N/A")
    }

    func didSelectRow(at index: IndexPath) {
        interactor.prepareRepositoryInformation(at: index.row, forCategoryIndex: index.section)
    }
    
    func addNewRepositoryButtonDidTouchUpInside() {
        interactor.prepareAddRepository()
    }
}

// MARK: - MyRepositoriesInteractorOutput

extension MyRepositoriesPresenter: MyRepositoriesInteractorOutput {

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

    func routeToAddingRepository() {
        router.routeToAddingRepository()
    }
    
    func routeToRepositoryInformation() {
        router.routeToRepositoryInformations()
    }
}

// MARK: - Privates

private struct MyRepositoriesViewModel: MyRepositoriesViewModelProtocol {
    var title: String
    var description: String
    var image: UIImage
    var ownerName: String
    var ownerImage: UIImage
    var lastUpdated: String
}
