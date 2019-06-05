//
//  FollowersListPresenterInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol FollowersListPresenterInput {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> FollowersListViewModelProtocol
}
