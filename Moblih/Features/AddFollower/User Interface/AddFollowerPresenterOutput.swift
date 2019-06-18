//
//  AddFollowerPresenterOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol AddFollowerPresenterOutput: class {
    func delegateLoading()
    func delegateSuccess()
    func delegateServerError(message: String)
    func delegateNetworkError(message: String)
    func displayAlertView(text: String,
                          message: String,
                          confirmationTitle: String,
                          cancelTitle: String)
}
