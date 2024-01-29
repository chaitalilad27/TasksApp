//
//  DateExtension.swift
//  Tasks
//
//  Created by Chaitali Lad on 24/01/24.
//

import Foundation

// MARK: Date Extension
extension Date {

    // Convert date to string
    func convertDateToString() -> String {
        let formattedDate = DateFormatter.defaultFormatter.string(from: self)
        return formattedDate
    }
}

// MARK: DateFormatter Extension
extension DateFormatter {

    // Static date formatter instance used for formatting dates
    static let defaultFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
}
