//
//  FollowerToDeleteRepositoryInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

enum FollowerToDeleteRepositoryError: Error {
    case noData
    case canNotSave
    case unknown
}

protocol FollowerToDeleteRepositoryInput {
    func get(success: ((String) -> Void)?,
             failure: ((FollowerToDeleteRepositoryError) -> Void)?)
    func save(login: String,
              success: (() -> Void)?,
              failure: ((FollowerToDeleteRepositoryError) -> Void)?)
    func clear(success: (() -> Void)?,
               failure: ((FollowerToDeleteRepositoryError) -> Void)?)
}
