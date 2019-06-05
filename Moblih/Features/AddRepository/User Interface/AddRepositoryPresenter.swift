//
//  AddRepositoryPresenter.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

final class AddRepositoryPresenter {

  // MARK: - Property

  weak var output: AddRepositoryPresenterOutput?
  private var interactor: AddRepositoryInteractorInput
  private var router: AddRepositoryRouterInput

  // MARK: - Lifecycle

  init(interactor: AddRepositoryInteractorInput, router: AddRepositoryRouterInput) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Converting

}

// MARK: - AddRepositoryPresenterInput

extension AddRepositoryPresenter: AddRepositoryPresenterInput {
  func viewDidLoad() {
  
  }
}

// MARK: - AddRepositoryInteractorOutput

extension AddRepositoryPresenter: AddRepositoryInteractorOutput {

}
