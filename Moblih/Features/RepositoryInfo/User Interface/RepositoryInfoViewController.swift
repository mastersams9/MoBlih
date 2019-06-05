//
//  RepositoryInfoViewController.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 13/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class RepositoryInfoViewController: UIViewController, Loadable {

    var presenter: RepositoryInfoPresenterInput?
    
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    @IBOutlet weak var repositoryStartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension RepositoryInfoViewController: RepositoryInfoPresenterOutput {
    func startLoader() {
        startLoading()
    }
    
    func stopLoader() {
        stopLoading()
    }
    
    func displayRepositoryInformation(viewModel: RepositoryInfoRepositoryViewModelProtocol) {
        self.repositoryNameLabel.text = viewModel.name
        self.repositoryDescriptionLabel.text = viewModel.description
        self.repositoryStartLabel.text = viewModel.starCountText
    }
    
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }
}
