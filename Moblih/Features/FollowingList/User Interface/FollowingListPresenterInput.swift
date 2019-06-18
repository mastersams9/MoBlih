//
//  FollowingListPresenterInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol FollowingListPresenterInput {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func titleForDeleteConfirmationButtonForRowAt(_ indexPath: IndexPath) -> String
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> FollowingListViewModelProtocol
    func addFollowerViewDidFinishWithSuccess()
    func refresherAttributedTitle() -> NSAttributedString
    func refresherControlDidTriggerRefresh()
    func tableViewCommit(_ editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    func deleteFollowerViewDidFinishWithSuccess()
}
