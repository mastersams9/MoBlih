//
//  AddRepositoryInteractorOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol AddRepositoryInteractorOutput: class {
    func notifyLoading()
    func setDefaultValues()
    func notifyEmptyNameError()
    func notifyCreationSuccess()
    func notifyNetworkError()
    func notifyServerError()
    func notifyRepositoryAlreadyExistsError()
    func notifyNoData()
    func enablePrivate()
    func disablePrivate()
    func enableAddReadme()
    func disableAddReadme()
    func updateName(_ name: String)
    func routeToMyRepositories()
}
