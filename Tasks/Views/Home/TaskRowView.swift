//
//  TaskRowView.swift
//  Tasks
//
//  Created by Chaitali Lad on 04/01/24.
//

import SwiftUI

struct TaskRowView: View {

    // MARK: - Properties

    @ObservedObject var task: Task
    @EnvironmentObject var dataManager: DataManager
    @State private var showAlert: AppAlert?

    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .top, content: {
            markCompletedButton

            VStack(alignment: .leading, spacing: 10) {
                taskInfoSection
                if !task.taskDetails.isEmpty {
                    taskDetailsSection
                }
            }
        })
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
        .listRowSeparator(.hidden)
        .swipeActions(content: { deleteButton })
        .alert(item: $showAlert) { appAlert in
            Alert(
                title: Text(appAlert.title),
                message: Text(appAlert.message),
                dismissButton: .default(Text(NSLocalizedString("ok", comment: "")))
            )
        }
    }

    // MARK: - Task Info Section

    private var taskInfoSection: some View {
        HStack(spacing: 10) {
            Text(task.taskName)
                .font(.title2)

            Spacer()

            starToggle
            bellToggle
        }
    }

    private var markCompletedButton: some View {
        ToggleImageView(selectedImageName: "checkmark.circle.fill", unSelectedImageName: "circle", size: CGSize(width: 25, height: 25), selectedImageColor: .appThemeColor, unSelectedImageColor: .gray.opacity(0.7), isSelected: $task.isCompleted) {
            _ = dataManager.saveChanges()
        }
        .padding(2)
    }

    private var starToggle: some View {
        ToggleImageView(selectedImageName: "star.fill", unSelectedImageName: "star", isSelected: $task.isStarred) {
            _ = dataManager.saveChanges()
        }
    }

    private var bellToggle: some View {
        ToggleImageView(selectedImageName: "bell.fill", unSelectedImageName: "bell", isSelected: $task.isNotifyOn) {
            _ = dataManager.saveChanges()
        }
    }

    // MARK: - Task Details Section

    private var taskDetailsSection: some View {
        Text(task.taskDetails)
            .font(.body)
            .foregroundColor(.gray.opacity(0.8))
            .lineLimit(1)
    }

    // MARK: - Delete Button

    private var deleteButton: some View {
        Button(role: .destructive, action: {
            deleteTask()
        }, label: {
            Image(systemName: "trash")
        })
    }

    // MARK: - Delete Task

    /// Deletes the task from the data manager.
    private func deleteTask() {
        dataManager.deleteTask(task) { result in
            switch result {
            case .success:
                print("Task deleted successfully!")
            case .failure:
                showAlert = AppAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("somethingWentWrong", comment: ""))
            }
        }
    }
}

// MARK: - Preview

struct TaskRowView_Previews: PreviewProvider {

    static var previews: some View {
        let task = Task(id: UUID(), taskName: "Task", taskDetails: "Details", isCompleted: false, isStarred: true, isNotifyOn: false)
        return TaskRowView(task: task)
    }
}
