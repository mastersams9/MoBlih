//
//  MyProfileDetailsInteractorInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

public protocol MyProfileDetailsInteractorInput {
  var output: MyProfileDetailsInteractorOutput? { get set }

    func retrieve()
    func refresh()
    func prepareFollowing()
    func prepareFollowers()
}
