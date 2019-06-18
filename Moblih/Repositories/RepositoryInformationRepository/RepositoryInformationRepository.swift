//
//  RepositoryInformationRepository.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

class RepositoryInformationRepository {

    static let shared = RepositoryInformationRepository()

    private var response = RepositoryInformationRepositoryItem()
}

extension RepositoryInformationRepository: RepositoryInformationRepositoryProtocol {

    func get(success: ((RepositoryInformationRepositoryItemProtocol) -> Void)?,
             failure: ((RepositoryInformationRepositoryError) -> Void)?) {
        guard response.owner != nil, response.name != nil else {
            failure?(.noData)
            return
        }
        success?(response)
    }

    func save(owner: String?,
              name: String?,
              success: (() -> Void)?,
              failure: ((RepositoryInformationRepositoryError) -> Void)?) {
        response = RepositoryInformationRepositoryItem(owner: owner,
                                                       name: name)
        success?()
    }

    func clear(success: (() -> Void)?,
               failure: ((RepositoryInformationRepositoryError) -> Void)?) {
        response = RepositoryInformationRepositoryItem(owner: nil,
                                                       name: nil)
        success?()
    }
}

// MARK: - Privates

private struct RepositoryInformationRepositoryItem: RepositoryInformationRepositoryItemProtocol {
    var owner: String?
    var name: String?
}
