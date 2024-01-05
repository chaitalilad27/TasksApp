//
//  ViewExtension.swift
//  Tasks
//
//  Created by Chaitali Lad on 04/01/24.
//

import SwiftUI

extension View {

    // MARK: - Navigation Bar Style

    /// Sets a custom navigation bar style for the view.
    /// - Parameters:
    ///   - title: The title to be displayed in the navigation bar.
    ///   - displayMode: The display mode for the navigation bar title.
    ///   - navigationBarColor: The background color for the navigation bar.
    /// - Returns: A modified view with the specified navigation bar style.
    func navigationBarStyle(title: String, displayMode: NavigationBarItem.TitleDisplayMode = .inline, navigationBarColor: Color = Color.appThemeColor) -> some View {
        self.navigationTitle(NSLocalizedString(title, comment: ""))  // Set the localized title for the navigation bar
            .toolbarColorScheme(.dark, for: .navigationBar)  // Set color scheme for the navigation bar
            .navigationBarTitleDisplayMode(displayMode)  // Set the display mode for the navigation bar title
            .toolbarBackground(navigationBarColor, for: .navigationBar)  // Set the background color for the navigation bar
            .toolbarBackground(.visible, for: .navigationBar)  // Make the navigation bar background visible
    }
}
