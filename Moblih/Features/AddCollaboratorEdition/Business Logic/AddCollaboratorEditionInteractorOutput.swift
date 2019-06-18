//
//  AddCollaboratorEditionInteractorOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol AddCollaboratorEditionInteractorOutput: class {

    func setDefaultValues()
    func notifyLoading()
    func notifyEmptyLoginError()
    func notifyAddCollaboratorSuccess()
    func notifyNetworkError()
    func notifyServerError()
    func notifyCollaboratorAlreadyExistsError()
    func updateLogin(_ login: String)
    func notifyNoData()
    func updateCategories()
    func selectPermission(section: Int)
    func routeBack()
}
