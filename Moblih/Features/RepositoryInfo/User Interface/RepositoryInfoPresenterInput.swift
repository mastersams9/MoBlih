//
//  RepositoryInfoPresenterInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation


protocol RepositoryInfoPresenterInput {
    func viewDidLoad()
    func refresherControlDidTriggerRefresh()
    func refresherAttributedTitle() -> NSAttributedString
    func manageCollaboratorsDidTouchUpInside()
}
