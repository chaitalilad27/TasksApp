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

    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .top, spacing: 5,content: {
            markCompletedButton

            VStack(alignment: .leading, spacing: 10) {
                taskInfoSection
                taskDetailsSection
            }
        })
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
        .padding(5)
        .listRowSeparator(.hidden)
    }

    // MARK: - Task Info Section

    private var taskInfoSection: some View {
        HStack(spacing: 10) {
            Text(task.taskName)
                .font(.title2)
                .foregroundColor(.black)

            Spacer()

            starToggle
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

    // MARK: - Task Details Section

    private var taskDetailsSection: some View {
        HStack {
            if !task.taskDetails.isEmpty {
                Text(task.taskDetails)
                    .font(.body)
                    .foregroundColor(.gray.opacity(0.8))
                    .lineLimit(1)
            }

            Spacer()

            Text(task.updatedAt.convertDateToString())
                .font(.callout)
                .foregroundColor(.gray.opacity(0.8))
                .lineLimit(1)
        }
    }
}

// MARK: - Preview

struct TaskRowView_Previews: PreviewProvider {

    static var previews: some View {
        let task = Task(id: UUID(), taskName: "Task", taskDetails: "Details", isCompleted: false, isStarred: true, isNotifyOn: false, taskCategory: TaskCategory())
        return TaskRowView(task: task)
    }
}
