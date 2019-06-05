//
//  MyRepositoriesRouterInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol MyRepositoriesRouterInput {

    func routeToAddingRepository()
    func routeToRepositoryInformations(with id: Int)
}
