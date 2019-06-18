//
//  FollowerToDeleteRepository.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class FollowerToDeleteRepository {

    static let shared = FollowerToDeleteRepository()

    private var username: String?
}

extension FollowerToDeleteRepository: FollowerToDeleteRepositoryInput {

    func get(success: ((String) -> Void)?,
             failure: ((FollowerToDeleteRepositoryError) -> Void)?) {
        guard let username = self.username else {
            failure?(.noData)
            return
        }
        success?(username)
    }

    func save(login: String,
              success: (() -> Void)?,
              failure: ((FollowerToDeleteRepositoryError) -> Void)?) {
        username = login
        success?()
    }

    func clear(success: (() -> Void)?,
               failure: ((FollowerToDeleteRepositoryError) -> Void)?) {
        username = nil
        success?()
    }
}
