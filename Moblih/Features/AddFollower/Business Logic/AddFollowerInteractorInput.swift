//
//  AddFollowerInteractorInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol AddFollowerInteractorInput {
  var output: AddFollowerInteractorOutput? { get set }

    func request()
    func confirm()
    func updateFollowerUsername(_ username: String?)
}
