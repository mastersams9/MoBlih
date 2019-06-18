//
//  MyProfileInteractorInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol MyProfileInteractorInput {
  var output: MyProfileInteractorOutput? { get set }

    func prepare()
    func prepareFollowingView()
    func prepareFollowersView()
    func prepareLogout()
    func prepareRepositoryInformation(at index: Int, forCategoryIndex categoryIndex: Int)
    func refresh()
    func handleNetworkError(on category: Category)
    func quit()
    func numberOfCategories() -> Int
    func numberOfItems(atCategoryIndex categoryIndex: Int) -> Int
    func item(at index: Int, forCategoryIndex categoryIndex: Int) -> MyRepositoriesRepositoryItemProtocol?
}
