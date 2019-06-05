//
//  MyRepositoriesInteractorInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol MyRepositoriesRepositoryItemProtocol {
    var name: String { get }
    var description: String? { get }
    var isPrivate: Bool { get }
    var ownerName: String? { get }
    var ownerAvatarData: Data? { get }
    var lastUpdatedDate: Date? { get }
}

public protocol MyRepositoriesInteractorInput {
    var output: MyRepositoriesInteractorOutput? { get set }
    func fetch()
    func refresh()
    func numberOfCategories() -> Int
    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int
    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> MyRepositoriesRepositoryItemProtocol?
    func prepareAddRepository()
    func prepareRepositoryInformation(at index: Int, forCategoryIndex categoryIndex: Int)
}
