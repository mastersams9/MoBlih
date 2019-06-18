//
//  RepositoryInformationRepositoryProtocol.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol RepositoryInformationRepositoryItemProtocol {
    var owner: String? { get }
    var name: String? { get }
}

enum RepositoryInformationRepositoryError: Error {
    case noData
    case canNotSave
    case unknown
}

protocol RepositoryInformationRepositoryProtocol {
    func get(success: ((RepositoryInformationRepositoryItemProtocol) -> Void)?,
             failure: ((RepositoryInformationRepositoryError) -> Void)?)
    func save(owner: String?,
              name: String?,
              success: (() -> Void)?,
              failure: ((RepositoryInformationRepositoryError) -> Void)?)
    func clear(success: (() -> Void)?,
               failure: ((RepositoryInformationRepositoryError) -> Void)?)
}

