//
//  followingListInteractorInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol FollowingListInteractorInput {
    var output: FollowingListInteractorOutput? { get set }
    
    func retrieve()
    func refresh()
    func refreshAfterDelete()
    func numberOfCategories() -> Int
    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int
    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> FollowingItemProtocol?
    func prepareDelete(at index: Int, forCategoryIndex categoryIndex: Int)
}
