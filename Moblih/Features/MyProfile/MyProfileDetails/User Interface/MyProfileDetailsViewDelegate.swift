//
//  MyProfileDetailsViewDelegate.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol MyProfileDetailsViewDelegate: class {

    func myProfileDetailsViewDidFinishWithSuccess()
    func myProfileDetailsViewDidTriggerServerError(_ title: String, message: String, confirmationTitle: String)
    func myProfileDetailsViewDidTriggerNetworkError(_ title: String, message: String, confirmationTitle: String)
    func myProfileDetailsViewFollowersButtonDidTouchUp()
    func myProfileDetailsViewFollowingButtonDidTouchUp()
}

extension MyProfileDetailsViewDelegate {
    func myProfileDetailsViewDidFinishWithSuccess() {}
}
