//
//  AddFollowerInteractorOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol AddFollowerInteractorOutput: class {
    func notifyLoading()
    func notifySuccess()
    func notifyServerError()
    func notifyNetworkError()
    func notifyEmptyUsernameError()
    func notifyRequest()
}
