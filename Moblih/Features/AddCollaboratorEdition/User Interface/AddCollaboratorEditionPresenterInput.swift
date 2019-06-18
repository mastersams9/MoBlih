//
//  AddCollaboratorEditionPresenterInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol AddCollaboratorEditionPresenterInput {
    func viewDidLoad()
    func addButtonDidTouchUpInside()
    func usernameLoginTextfieldDidUpdateText(_ text: String?)
    func permissionsSegmentedControlDidValueChanged(_ segmentIndex: Int)
    func numberOfSegments() -> Int
    func titleOfSegments(at index: Int) -> String
}
