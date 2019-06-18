//
//  DeleteFollowerViewDelegate.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol DeleteFollowerViewDelegate: class {
    func deleteFollowerViewDidFinishWithSuccess()
    func deleteFollowerViewDidTriggerServerError(message: String)
    func deleteFollowerViewDidTriggerNetworkError(message: String)
}
