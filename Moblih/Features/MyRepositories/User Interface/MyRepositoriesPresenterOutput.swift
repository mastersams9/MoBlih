//
//  MyRepositoriesPresenterOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol MyRepositoriesPresenterOutput: class {

    func startLoader()
    func stopLoader()
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String)
    func reloadData()
}
