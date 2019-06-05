//
//  MyProfileDetailsPresenterOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol MyProfileDetailsViewModelProtocol {
    var name: String { get }
    var login: String { get }
    var image: UIImage { get }
    var company: String { get }
    var numberOfRepositories: String { get }
}

protocol MyProfileDetailsPresenterOutput: class {
    func startLoader()
    func stopLoader()
    func displayProfileInformation(_ profileInformation: MyProfileDetailsViewModelProtocol)
    func delegateServerError(_ title: String, message: String, confirmationTitle: String)
    func delegateNetworkError(_ title: String, message: String, confirmationTitle: String)
    func delegateSuccess()
    func delegateFollowingButtonDidTouchUp()
    func delegateFollowersButtonDidTouchUp()
}
