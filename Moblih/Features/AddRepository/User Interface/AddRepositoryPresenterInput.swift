//
//  AddRepositoryPresenterInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol AddRepositoryPresenterInput {
  func viewDidLoad()
    func nameTextfieldDidUpdateText(_ text: String?)
    func descriptionTextfieldDidUpdateText(_ text: String?)
    func didTapCreateButton()
    func addReadmeSwitchValueDidChange(_ value: Bool)
    func privateSwitchValueDidChange(_ value: Bool)
}
