//
//  MyRepositoriesInteractorOutput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol MyRepositoriesInteractorOutput: class {
    func notifySuccess()
    func notifyLoading()
    func notifyServerError()
    func notifyNetworkError()
    func routeToAddingRepository()
    func routeToRepositoryInformation(with id: Int)
}
