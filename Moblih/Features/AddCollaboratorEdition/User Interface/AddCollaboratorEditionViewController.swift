//
//  AddCollaboratorEditionViewController.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 16/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit
import MaterialComponents.MDCTextField

class AddCollaboratorEditionViewController: UIViewController, Loadable {

    // MARK: - Outlets

    @IBOutlet weak var userLoginTextField: MDCTextField! {
        didSet {
            userLoginTextField.delegate = self
        }
    }
    @IBOutlet weak var permissionsTextLabel: UILabel!
    @IBOutlet weak var permissionsSegmentedControl: UISegmentedControl! {
        didSet {
            permissionsSegmentedControl.isHidden = true
            permissionsSegmentedControl.addTarget(self,
                                              action: #selector(permissionsSegmentedControlDidValueChanged),
                                              for: .valueChanged)
        }
    }
    @IBOutlet weak var addButton: UIButton!

    // MARK: - Property
    
    var presenter: AddCollaboratorEditionPresenterInput!
    private var nameOutlineController: MDCTextInputControllerOutlined!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOutlineController = MDCTextInputControllerOutlined(textInput: userLoginTextField)
        self.presenter?.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonDidTouchUpInside(_ sender: UIButton) {
        presenter.addButtonDidTouchUpInside()
    }

    @objc private func permissionsSegmentedControlDidValueChanged(_ segment: UISegmentedControl) {
        presenter.permissionsSegmentedControlDidValueChanged(segment.selectedSegmentIndex)
    }
}

// MARK: - UITextFieldDelegate

extension AddCollaboratorEditionViewController: UITextFieldDelegate {

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        updateTextfieldText(textField.text, for: textField)
        return true
    }

    private func updateTextfieldText(_ text: String?, for textField: UITextField) {
        if textField == userLoginTextField {
            presenter.usernameLoginTextfieldDidUpdateText(text)
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


// MARK: - AddCollaboratorEditionPresenterOutput

extension AddCollaboratorEditionViewController: AddCollaboratorEditionPresenterOutput {

    func startLoader() {
        startLoading()
    }

    func stopLoader() {
        stopLoading()
    }

    func reloadSegmentedControl() {
        permissionsSegmentedControl.removeAllSegments()
        for i in 0 ..< presenter.numberOfSegments() {
            permissionsSegmentedControl.insertSegment(withTitle: presenter.titleOfSegments(at: i),
                                                  at: i,
                                                  animated: true)
        }
        permissionsSegmentedControl.isHidden = false
    }

    func selectSegmentedControl(at index: Int) {
        permissionsSegmentedControl.selectedSegmentIndex = index
    }

    func setPlaceHolders(placeholder: AddCollaboratorEditionViewModelPlaceholdersProtocol) {
        title = placeholder.viewTitle
        userLoginTextField.placeholder = placeholder.usernameLogin
        permissionsTextLabel.text = placeholder.permissionsText
        addButton.setTitle(placeholder.addButtonTitleText, for: .normal)
    }

    func displayAlertPopupWithTitle(_ title: String, message: String, confirmationTitle: String) {
        presentAlertPopupWithTitle(title, message: message, confirmationTitle: confirmationTitle)
    }

    func setErrorNameText(_ text: String?) {
        nameOutlineController.setErrorText(text, errorAccessibilityValue: nil)
    }

    func displayLogin(_ login: String) {
        userLoginTextField.text = login
    }
}
