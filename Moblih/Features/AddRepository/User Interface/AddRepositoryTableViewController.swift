//
//  AddRepositoryTableViewController.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 02/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

public protocol AddRepositoryTableViewControllerDelegate: class {
    func addRepositoryTableViewControllerDidFinish()
}

class AddRepositoryTableViewController: UITableViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var nameTextfield: MDCTextField! {
        didSet {
            nameTextfield.delegate = self
        }
    }
    @IBOutlet weak var descriptionTextfield: MDCTextField! {
        didSet {
            descriptionTextfield.delegate = self
        }
    }
    
    @IBOutlet weak var addReadMeLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var privateLabel: UILabel!
    
    @IBOutlet weak var addReadMeSwitch: UISwitch!
    
    
    @IBOutlet weak var privateSwitch: UISwitch!
    
    private var nameOutlineController: MDCTextInputControllerOutlined!
    private var descriptionOutlineController: MDCTextInputControllerOutlined!

    // MARK: - Property

    var presenter: AddRepositoryPresenterInput!

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter?.viewDidLoad()
    nameOutlineController = MDCTextInputControllerOutlined(textInput: nameTextfield)
    descriptionOutlineController = MDCTextInputControllerOutlined(textInput: descriptionTextfield)
  }

    @IBAction func createButtonDidTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        presenter.didTapCreateButton()
    }
    
    @IBAction func addReadmeSwitchValueDidChange(_ sender: UISwitch) {
        presenter.addReadmeSwitchValueDidChange(sender.isOn)
    }
    
    @IBAction func privateSwitchValueDidChange(_ sender: UISwitch) {
        presenter.privateSwitchValueDidChange(sender.isOn)
    }
}

// MARK: - UITextFieldDelegate

extension AddRepositoryTableViewController: UITextFieldDelegate {

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        updateTextfieldText(textField.text, for: textField)
        return true
    }

    private func updateTextfieldText(_ text: String?, for textField: UITextField) {
        if textField == nameTextfield {
            presenter.nameTextfieldDidUpdateText(text)
        } else if textField == descriptionTextfield {
            presenter.descriptionTextfieldDidUpdateText(text)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateTextfieldText(textField.text, for: textField)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if var text = textField.text {
            if string.isEmpty {
                updateTextfieldText(String(text.dropLast()), for: textField)
            } else {
                let location = text.index(text.startIndex, offsetBy: range.location)
                for character in string.reversed() {
                    text.insert(character, at: location)
                }
                updateTextfieldText(text, for: textField)
            }
        }
        return true
    }
}

// MARK: - AddRepositoryPresenterOutput

extension AddRepositoryTableViewController: AddRepositoryPresenterOutput {
    func startLoader() {
        tableView.startLoading()
    }
    
    func stopLoader() {
        tableView.stopLoading()
    }
    
    func displayName(_ name: String) {
        nameTextfield.text = name
    }

    func updatePrivateSwitchEnability(_ enabled: Bool) {
        privateSwitch.isOn = enabled
    }
    
    func updateAddReadmeSwitchEnability(_ enabled: Bool) {
        addReadMeSwitch.isOn = enabled
    }
    
    func setPlaceHolders(placeholder: AddRepositoryViewModelPlaceholdersProtocol) {
        nameTextfield.placeholder = placeholder.name
        descriptionTextfield.placeholder = placeholder.description
        privateLabel.text = placeholder.privateText
        addReadMeLabel.text = placeholder.addReadmeText
        addButton.setTitle(placeholder.createButtonTitleText, for: .normal)
    }
    
    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }
    
    func setErrorNameText(_ text: String?) {
        nameOutlineController.setErrorText(text, errorAccessibilityValue: nil)
    }
}
