//
//  AddFollowerPresenterInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol AddFollowerPresenterInput {
    func addButtonDidTouchUpInside()
    func confirmButtonDidTouchUpInside()
    func textfieldDidUpdateText(_ text: String?)
}
