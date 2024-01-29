//
//  TasksApp.swift
//  Tasks
//
//  Created by Chaitali Lad on 02/01/24.
//

import SwiftUI

@main
struct TasksApp: App {

    // MARK: - Properties
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var manager: DataManager = DataManager()
    @StateObject private var authManager = AuthManager()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            if authManager.isUserLoggedIn {
                HomeView()
                    .environmentObject(authManager)
                    .environmentObject(manager)  // Inject DataManager as an environment object
                    .environment(\.managedObjectContext, manager.container.viewContext)  // Inject CoreData managed object context
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
