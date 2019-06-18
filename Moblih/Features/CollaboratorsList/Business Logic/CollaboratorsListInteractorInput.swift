//
//  CollaboratorsListInteractorInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol CollaboratorsListInteractorInput {
  var output: CollaboratorsListInteractorOutput? { get set }

    func retrieve()
    func refresh()
    func refreshAfterDelete()
    func numberOfCategories() -> Int
    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int
    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> CollaboratorsItemProtocol?
    func prepareDelete(at index: Int, forCategoryIndex categoryIndex: Int)
}
