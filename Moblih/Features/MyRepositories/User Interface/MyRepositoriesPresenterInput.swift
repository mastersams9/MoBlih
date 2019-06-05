//
//  MyRepositoriesPresenterInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 11/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

protocol MyRepositoriesViewModelProtocol {
    var title: String { get }
    var description: String { get }
    var image: UIImage { get }
    var ownerName: String { get }
    var ownerImage: UIImage { get }
    var lastUpdated: String { get }
}

protocol MyRepositoriesPresenterInput {
    func viewDidLoad()
    func refresherAttributedTitle() -> NSAttributedString
    func refresherControlDidTriggerRefresh()
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func viewModelAtIndexPath(_ indexPath: IndexPath) -> MyRepositoriesViewModelProtocol
    func addNewRepositoryButtonDidTouchUpInside()
    func didSelectRow(at index: IndexPath)
}
