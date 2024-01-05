//
//  AppAlert.swift
//  Tasks
//
//  Created by Chaitali Lad on 05/01/24.
//

import Foundation

// A structure representing an alert in the app.
struct AppAlert: Identifiable {

    // MARK: - Properties

    var id = UUID()   // Unique identifier for conforming to Identifiable protocol
    var title: String  // Title of the alert
    var message: String  // Message content of the alert
}
