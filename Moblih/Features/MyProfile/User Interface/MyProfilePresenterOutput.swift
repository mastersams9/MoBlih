//
//  MyProfilePresenterOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

enum CategoryView {
    case logoutButtonItem
    case myProfileDetails
}

protocol MyProfilePresenterOutput: class {

    func startLoader()
    func stopLoader()
    func displayViewCategories(_ categories: [CategoryView])
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func reloadData()
}
