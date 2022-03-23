//
//  AuthorizationScreenController+Extension.swift
//  Photo_swiping
//
//  Created by Дмитрий Молодецкий on 21.03.2022.
//

import Foundation
import UIKit

extension AuthorizationScreenController: UITextFieldDelegate {
    
    func authorizationScreen(_ authorizationScreen: AuthorizationScreenView, passwordIncorrect alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func authorizationScreen(_ authorizationScreen: AuthorizationScreenView, login user: User) {
        let vc = PhotoCollectionController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let fieldIndex = self.authorizationScreen.textFields.firstIndex(of: textField),
           fieldIndex + 1 < authorizationScreen.textFields.count {
            authorizationScreen.textFields[fieldIndex + 1].becomeFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string),
              let fieldIndex = authorizationScreen.textFields.firstIndex(of: textField),
              let textFieldType = TextFieldType.textFieldType(for: fieldIndex) else { return true }
        
        return textFieldType.restrictContentFunction()(newString)
    }
    
    func textFromField(fieldType: TextFieldType) -> String {
        guard let text = authorizationScreen.textFields[fieldType.textFieldIndex()].text else { return "" }
        return text
    }
}
