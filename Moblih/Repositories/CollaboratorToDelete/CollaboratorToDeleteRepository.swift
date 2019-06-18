//
//  CollaboratorToDeleteRepository.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class CollaboratorToDeleteRepository {

    static let shared = CollaboratorToDeleteRepository()

    private var username: String?
}

extension CollaboratorToDeleteRepository: CollaboratorToDeleteRepositoryInput {

    func get(success: ((String) -> Void)?,
             failure: ((CollaboratorToDeleteRepositoryError) -> Void)?) {
        guard let username = self.username else {
            failure?(.noData)
            return
        }
        success?(username)
    }

    func save(login: String,
              success: (() -> Void)?,
              failure: ((CollaboratorToDeleteRepositoryError) -> Void)?) {
        username = login
        success?()
    }

    func clear(success: (() -> Void)?,
               failure: ((CollaboratorToDeleteRepositoryError) -> Void)?) {
        username = nil
        success?()
    }
}
