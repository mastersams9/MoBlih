//
//  AddCollaboratorEditionInteractorInput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public enum AddCollaboratorEditionInteractorPermissionCategory {
    case admin
    case push
    case pull
}

public protocol AddCollaboratorEditionInteractorInput {
  var output: AddCollaboratorEditionInteractorOutput? { get set }

    func retrieve()
    func execute()
    func updateLogin(_ login: String?)
    func numberOfSections() -> Int
    func sectionCategory(at section: Int) -> AddCollaboratorEditionInteractorPermissionCategory?
    func selectPermission(at section: Int)
}
