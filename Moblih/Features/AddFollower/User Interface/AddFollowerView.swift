//
//  AddFollowerView.swift
//  Moblih
//
//
//  Created by Sami Benmakhlouf on 13/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class AddFollowerView: UIView {

    // MARK: - Property

    weak var delegate: AddFollowerViewDelegate?
    weak var parentViewController: UIViewController?

    var presenter: AddFollowerPresenterInput!
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Button Actions

    @IBAction func addButtonDidTouchUpInside(_ sender: UIButton) {
        presenter.addButtonDidTouchUpInside()
    }
}

// MARK: - AddFollowerPresenterOutput

extension AddFollowerView: AddFollowerPresenterOutput {
    func displayAlertView(text: String, message: String, confirmationTitle: String, cancelTitle: String) {
        parentViewController?.presentAlertPopupWithTextfield(text,
                                                         message: message,
                                                         textFieldConfigurationHandler: { [weak self] textfield in
                                                            textfield.delegate = self
        },
                                                         confirmationTitle: confirmationTitle,
                                                         cancelTitle: cancelTitle,
                                                         confirmHandler: { [weak self] _ in
                                                            self?.presenter.confirmButtonDidTouchUpInside()
            }, cancelHandler: nil)
    }
    
    func delegateLoading() {
        delegate?.addFollowerViewIsRequesting()
    }
    
    func delegateSuccess() {
        delegate?.addFollowerViewDidFinishWithSuccess()
    }

    func delegateServerError(message: String) {
        delegate?.addFollowerViewDidTriggeredServerError(message: message)
    }

    func delegateNetworkError(message: String) {
        delegate?.addFollowerViewDidTriggeredNetworkError(message: message)
    }
}

// MARK: - UITextFieldDelegate

extension AddFollowerView: UITextFieldDelegate {

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        updateTextfieldText(textField.text, for: textField)
        return true
    }

    private func updateTextfieldText(_ text: String?, for textField: UITextField) {
        presenter.textfieldDidUpdateText(text)
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
