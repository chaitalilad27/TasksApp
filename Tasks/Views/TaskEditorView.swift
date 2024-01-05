//
//  TaskEditorView.swift
//  Tasks
//
//  Created by Chaitali Lad on 02/01/24.
//

import SwiftUI

struct TaskEditorView: View {

    // MARK: - Properties

    @EnvironmentObject private var dataManager: DataManager
    @Environment(\.presentationMode) private var presentationMode

    private var isEditingTask: Bool
    private var task: Task?
    private var taskID: UUID { task?.id ?? UUID() }

    @State private var taskName: String
    @State private var taskDescription: String
    @State private var isStarred: Bool
    @State private var isNotifyOn: Bool
    @State private var showAlert: AppAlert?

    // MARK: - Initializer

    init(task: Task? = nil) {
        self.isEditingTask = task != nil
        self.task = task
        self._taskName = State(initialValue: task?.taskName ?? "")
        self._taskDescription = State(initialValue: task?.taskDetails ?? "")
        self._isStarred = State(initialValue: task?.isStarred ?? false)
        self._isNotifyOn = State(initialValue: task?.isNotifyOn ?? false)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, content: {
            titleSection
            inputFieldsSection
            togglesSection
            saveUpdateButton
        })
        .padding(15)
        .background(Color.white.ignoresSafeArea(.all))
        .alert(item: $showAlert) { appAlert in
            Alert(
                title: Text(appAlert.title),
                message: Text(appAlert.message),
                dismissButton: .default(Text(NSLocalizedString("ok", comment: "")))
            )
        }
    }

    // MARK: - Subviews

    private var titleSection: some View {
        Text(isEditingTask ? NSLocalizedString("editTask", comment: "") : NSLocalizedString("addTask", comment: ""))
            .font(.title)
    }

    private var inputFieldsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            CustomTextField(placeholder: NSLocalizedString("taskName", comment: ""), text: $taskName)
            CustomTextField(placeholder: NSLocalizedString("taskDescription", comment: ""), text: $taskDescription)
        }
    }

    private var togglesSection: some View {
        HStack(spacing: 20) {
            Spacer()
            ToggleImageView(selectedImageName: "star.fill", unSelectedImageName: "star", size: CGSize(width: 35, height: 35), isSelected: $isStarred) { }
            ToggleImageView(selectedImageName: "bell.fill", unSelectedImageName: "bell", size: CGSize(width: 35, height: 35), isSelected: $isNotifyOn) { }
        }
        .padding(5)
    }

    private var saveUpdateButton: some View {
        Button(action: saveTask) {
            HStack {
                Spacer()
                Text((isEditingTask ? NSLocalizedString("update", comment: "") : NSLocalizedString("save", comment: "")).uppercased())
                    .font(.body)
                    .fontWeight(.bold)
                    .padding(15)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .frame(height: 50)
        .background(Color.appThemeColor)
        .cornerRadius(10)
    }

    // MARK: - Save Task

    private func saveTask() {
        guard validateTaskValues() else { return }

        if isEditingTask {
            if let existingTask = task {
                dataManager.updateTask(existingTask, withName: taskName, details: taskDescription, isStarred: isStarred, isNotifyOn: isNotifyOn) { result in
                    handleSaveUpdateResult(result)
                }
            } else {
                showAppAlert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("somethingWentWrong", comment: ""))
            }
        } else {
            dataManager.addTask(taskID: taskID, taskName: taskName, taskDetails: taskDescription, isStarred: isStarred, isNotifyOn: isNotifyOn) { result in
                handleSaveUpdateResult(result)
            }
        }
    }

    // MARK: - Validate Task Values

    private func validateTaskValues() -> Bool {
        guard !taskName.isEmpty else {
            showAppAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("taskNameMandatory", comment: ""))
            return false
        }
        return true
    }

    // MARK: - Handle Save/Update Result

    private func handleSaveUpdateResult(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            presentationMode.wrappedValue.dismiss()
        case .failure:
            showAppAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("somethingWentWrong", comment: ""))
        }
    }

    // MARK: - Show App Alert

    private func showAppAlert(title: String, message: String) {
        showAlert = AppAlert(title: title, message: message)
    }
}

// MARK: - Preview

struct TaskEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditorView()
    }
}
