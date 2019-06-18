//
//  AddFollowerViewDelegate.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol AddFollowerViewDelegate: class {
    func addFollowerViewIsRequesting()
    func addFollowerViewDidFinishWithSuccess()
    func addFollowerViewDidTriggeredServerError(message: String)
    func addFollowerViewDidTriggeredNetworkError(message: String)
    func addFollowerViewDidTriggeredBadUserError(message: String)
}
