//
//  AddRepositoryViewController.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AddRepositoryViewController: UIViewController {

  // MARK: - Property

  var presenter: AddRepositoryPresenterInput!

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter?.viewDidLoad()
  }
}

// MARK: - AddRepositoryPresenterOutput

extension AddRepositoryViewController: AddRepositoryPresenterOutput {

}
