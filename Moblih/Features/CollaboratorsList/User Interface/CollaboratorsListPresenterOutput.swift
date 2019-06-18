//
//  CollaboratorsListPresenterOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

enum CollaboratorsListCategoryView {
    case addButtonItem
}

protocol CollaboratorsListViewModelProtocol {
    var login: String { get }
    var image: UIImage { get }
    var permission: String { get }
}

protocol CollaboratorsListPresenterOutput: class {
    func startLoader()
    func stopLoader()
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func displayViewCategories(_ categories: [CollaboratorsListCategoryView])
    func reloadData()
    func commitDelete()
    func deleteRowsAtIndexPaths(_ indexPaths: [IndexPath],
                                with animation: UITableView.RowAnimation)
}
