//
//  CollaboratorsListPresenterInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol CollaboratorsListPresenterInput {
    var title: String { get }
    func viewWillAppear()
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> CollaboratorsListViewModelProtocol
    func refresherAttributedTitle() -> NSAttributedString
    func refresherControlDidTriggerRefresh()
    func tableViewCommit(_ editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    func deleteFollowerViewDidFinishWithSuccess()
    func addCollaboratorViewDidFinishWithSuccess()
}
