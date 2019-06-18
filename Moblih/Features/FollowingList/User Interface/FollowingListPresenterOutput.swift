//
//  FollowingListPresenterOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//
import UIKit

enum FollowingListCategoryView {
    case addButtonItem
}

protocol FollowingListViewModelProtocol {
    var name: String { get }
    var login: String { get }
    var image: UIImage { get }
    var company: String { get }
}

protocol FollowingListPresenterOutput: class {
    func startLoader()
    func stopLoader()
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func reloadData()
    func displayViewCategories(_ categories: [FollowingListCategoryView])
    func commitDelete()
    func deleteRowsAtIndexPaths(_ indexPaths: [IndexPath],
                                with animation: UITableView.RowAnimation)
}
