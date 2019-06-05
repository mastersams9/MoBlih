//
//  MyProfileDetailsPresenterInput.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol MyProfileDetailsPresenterInput {
    func viewDidLoad()
    func refresh()
    func followingButtonDidTouchUp()
    func followersButtonDidTouchUp()
}
