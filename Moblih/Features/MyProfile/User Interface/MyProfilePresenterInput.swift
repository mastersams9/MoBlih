//
//  MyProfilePresenterInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol MyProfilePresenterInput {
    func viewDidLoad()
    func refresherAttributedTitle() -> NSAttributedString
    func refresherControlDidTriggerRefresh()
    func logoutViewIsRequesting()
    func logoutViewDidFinish()
    func titleForHeaderInSection(_ section: Int) -> String
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> MyRepositoriesViewModelProtocol
    func myProfileDetailsViewDidTriggerNetworkError()
    func myProfileDetailsFollowersButtonDidTouchUp()
    func myProfileDetailsFollowingButtonDidTouchUp()
}
