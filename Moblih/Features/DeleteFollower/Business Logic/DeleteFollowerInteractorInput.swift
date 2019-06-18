//
//  DeleteFollowerInteractorInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol DeleteFollowerInteractorInput {
  var output: DeleteFollowerInteractorOutput? { get set }

    func execute()
}
