//
//  RemoveCollaboratorViewDelegate.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol RemoveCollaboratorViewDelegate: class {
    func removeCollaboratorViewDidFinishWithSuccess()
    func removeCollaboratorViewDidTriggerServerError(message: String)
    func removeCollaboratorViewDidTriggerNetworkError(message: String)
}
