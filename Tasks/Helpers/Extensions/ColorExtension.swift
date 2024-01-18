//
//  ColorExtension.swift
//  Tasks
//
//  Created by Chaitali Lad on 04/01/24.
//

import SwiftUI

extension Color {

    // MARK: - Custom App Colors

    static let appThemeColor = Color("appTheme")  // App's primary theme color
    static let appYellow = Color("appYellow")  // App's yellow color

    // MARK: - Random Color Generator

    // Generate a random color.
    static func random() -> Color {
        let red = CGFloat(arc4random_uniform(255))
        let green = CGFloat(arc4random_uniform(255))
        let blue = CGFloat(arc4random_uniform(255))
        let color = UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
        print(color)
        return Color(color)
    }
}
