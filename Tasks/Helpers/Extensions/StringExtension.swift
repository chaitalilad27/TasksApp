//
//  StringExtension.swift
//  Tasks
//
//  Created by Chaitali Lad on 16/01/24.
//

import Foundation

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
    var isAlphanumericWithNoSpaces: Bool {
        rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }

    var hasPunctuationCharacters: Bool {
        rangeOfCharacter(from: CharacterSet.punctuationCharacters) != nil
    }

    var hasNumbers: Bool {
        rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil
    }

    var localized: String {
        localize()
    }

    var withNoSpaces: String {
        filter { !$0.isWhitespace }
    }

    func localize(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }

    var validFilename: String {
        guard !isEmpty else { return "emptyFilename" }
        return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "emptyFilename"
    }

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

    //Regex fulfill RFC 5322 Internet Message format
    func isEmailValid() -> Bool {
        let predicate = NSPredicate(
            format: "SELF MATCHES %@",
            "[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?"
        )
        return predicate.evaluate(with: self)
    }

    func isPasswordValid() -> Bool {
        let predicate = NSPredicate(
            format: "SELF MATCHES %@",
            "[a-zA-Z0-9!@#$%^&*]{8,}"
        )
        return predicate.evaluate(with: self)
    }

    func isInteger() -> Bool {
        Int(self) != nil
    }

    func isPhoneNumber() -> Bool {
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", "^\\d{3}-\\d{3}-\\d{4}$")
        return phoneTest.evaluate(with: self)
    }
}
