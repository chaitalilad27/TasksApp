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

    @StateObject private var manager: DataManager = DataManager()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(manager)  // Inject DataManager as an environment object
                .environment(\.managedObjectContext, manager.container.viewContext)  // Inject CoreData managed object context
        }
    }
}
