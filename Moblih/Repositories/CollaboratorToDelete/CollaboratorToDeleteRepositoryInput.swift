//
//  CollaboratorToDeleteRepositoryInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

enum CollaboratorToDeleteRepositoryError: Error {
    case noData
    case canNotSave
    case unknown
}

protocol CollaboratorToDeleteRepositoryInput {
    func get(success: ((String) -> Void)?,
             failure: ((CollaboratorToDeleteRepositoryError) -> Void)?)
    func save(login: String,
              success: (() -> Void)?,
              failure: ((CollaboratorToDeleteRepositoryError) -> Void)?)
    func clear(success: (() -> Void)?,
               failure: ((CollaboratorToDeleteRepositoryError) -> Void)?)
}
