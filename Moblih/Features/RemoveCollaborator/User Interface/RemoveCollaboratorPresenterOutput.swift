//
//  RemoveCollaboratorPresenterOutput.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 15/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol RemoveCollaboratorPresenterOutput: class {
    func startLoader()
    func stopLoader()
    func delegateSuccess()
    func delegateServerError(message: String)
    func delegateNetworkError(message: String)
}
