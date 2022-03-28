//
//  TextFieldType+extension.swift
//  HomeWork19
//
//  Created by Дмитрий Молодецкий on 17.03.2022.
//

import Foundation
import UIKit

extension TextFieldType {
    
    // MARK: Data
    static func textFieldType(for textFieldIndex: Int) -> TextFieldType? {
        return Self.allCases.first { $0.textFieldIndex() == textFieldIndex }
    }
    
    func textFieldIndex() -> Int {
        return (Self.allCases.firstIndex(of: self) ?? 0)
    }
    
    func restrictContentFunction() -> ((String) -> (Bool)) {
        switch self {
        case .name: return restrictDefault(text:)
        case .password: return restrictPassword(text:)
        }
    }
    
    func checkInfoIsReadyFunction() -> ((String) -> (Bool)) {
        switch self {
        case .name: return checkName(text:)
        case .password: return checkPassword(text:)
        }
    }
    
    private func restrictPassword(text: String) -> Bool {
        return text.count <= 4
    }
    
    private func restrictDefault(text: String) -> Bool {
        return true
    }
    
    private func checkName(text: String) -> Bool {
        return true
    }
    
    private func checkPassword(text: String) -> Bool {
        if text.count < 4 {
            return false
        }
        else {
            return true
        }
    }
    
    // MARK: TextField setups
    func autocapitalizationType() -> UITextAutocapitalizationType {
        switch self {
        case .name: return .words
        case .password: return .none
        }
    }
    
    func autocorrectionType() -> UITextAutocorrectionType {
        switch self {
        case .name: return .no
        case .password: return .no
        }
    }
    
    func placeholder() -> String {
        switch self {
        case .password: return "Enter your password".localizable
        case .name: return "Enter your name".localizable
        }
    }
    
    func keyboardType() -> UIKeyboardType? {
        switch self {
        case .name: return .default
        case .password: return .numberPad
        }
    }
    
    func isSecurityText() -> Bool {
        switch self {
        case .name: return false
        case .password: return true
        }
    }
    
    func returnType() -> UIReturnKeyType {
        switch self {
        case .name: return .next
        case .password: return .done
        }
    }
}
