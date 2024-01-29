//
//  StringExtension.swift
//  Tasks
//
//  Created by Chaitali Lad on 16/01/24.
//

import Foundation

// Enum to define various validation types
enum ValidationType {
    case email
    case password
    case nonEmpty
    case numeric
    case date
    case phone
    case none
    case custom(isValid: () -> Bool)
}

extension String {

    // Checks if the string is alphanumeric with no spaces
    var isAlphanumericWithNoSpaces: Bool {
        rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }

    // Checks if the string has punctuation characters
    var hasPunctuationCharacters: Bool {
        rangeOfCharacter(from: CharacterSet.punctuationCharacters) != nil
    }

    // Checks if the string has numbers
    var hasNumbers: Bool {
        rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil
    }

    // Localizes the string
    var localized: String {
        localize()
    }

    // Removes spaces from the string
    var withNoSpaces: String {
        filter { !$0.isWhitespace }
    }

    // Localizes the string with a comment
    func localize(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }

    // Creates a valid filename from the string
    var validFilename: String {
        guard !isEmpty else { return "emptyFilename" }
        return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "emptyFilename"
    }

    // Validates the string based on the specified type
    func isValid(type: ValidationType, isRequired: Bool = true) -> Bool {
        guard isRequired || !isEmpty else { return true }
        switch type {
        case .email:
            return isEmailValid()
        case .password:
            return isPasswordValid()
        case .numeric:
            return isInteger()
        case .phone:
            return isPhoneNumber()
        case .none:
            return true
        case .custom(isValid: let validationBlock):
            return validationBlock()
        default:
            return !isEmpty
        }
    }

    // Checks if the string is a valid email address
    func isEmailValid() -> Bool {
        let predicate = NSPredicate(
            format: "SELF MATCHES %@",
            "[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?"
        )
        return predicate.evaluate(with: self)
    }

    // Checks if the string is a valid password
    func isPasswordValid() -> Bool {
        let predicate = NSPredicate(
            format: "SELF MATCHES %@",
            "[a-zA-Z0-9!@#$%^&*]{8,}"
        )
        return predicate.evaluate(with: self)
    }

    // Checks if the string is a valid integer
    func isInteger() -> Bool {
        Int(self) != nil
    }

    // Checks if the string is a valid phone number
    func isPhoneNumber() -> Bool {
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", "^\\d{3}-\\d{3}-\\d{4}$")
        return phoneTest.evaluate(with: self)
    }
}
