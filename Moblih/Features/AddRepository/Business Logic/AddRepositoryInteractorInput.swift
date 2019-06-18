//
//  AddRepositoryInteractorInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol AddRepositoryInteractorInput {
  var output: AddRepositoryInteractorOutput? { get set }

    func retrieve()
    func updateAddReadmeValue(value: Bool)
    func updateIsPrivateValue(value: Bool)
    func updateNameText(text: String)
    func updateDescriptionText(text: String)
    func create()
}
