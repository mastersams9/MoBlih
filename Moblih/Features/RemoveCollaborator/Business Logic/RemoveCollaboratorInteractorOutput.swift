//
//  RemoveCollaboratorInteractorOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol RemoveCollaboratorInteractorOutput: class {
    func notifyLoading()
    func notifySuccess()
    func notifyServerError()
    func notifyNetworkError()
    func notifyRemoveSameOwnerAndCollaboratorError()
}
