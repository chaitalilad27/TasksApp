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
    @State private var newCategory: String = ""
    @State private var category: TaskCategory?
    @State private var showAlert: AppAlert?

    // MARK: - Initializer

    init(task: Task? = nil) {
        self.isEditingTask = task != nil
        self.task = task
        self._taskName = State(initialValue: task?.taskName ?? "")
        self._taskDescription = State(initialValue: task?.taskDetails ?? "")
        self._isStarred = State(initialValue: task?.isStarred ?? false)
        self._isNotifyOn = State(initialValue: task?.isNotifyOn ?? false)
        self._category = State(initialValue: task?.category)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, content: {
            inputFieldsSection
            togglesSection
            categoryView
            Spacer()
            saveUpdateButton
        })
        .padding(.vertical, 25)
        .padding(.horizontal, 15)
        .background(Color.white.ignoresSafeArea(.all))
        .navigationBarStyle(title: isEditingTask ? "editTask" : "addTask")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .foregroundColor(.white)
                }
            }

            if let task = task {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        deleteTask(task)
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .alert(item: $showAlert) { appAlert in
            Alert(
                title: Text(appAlert.title),
                message: Text(appAlert.message),
                dismissButton: .default(Text("ok".localized))
            )
        }
    }

    // MARK: - Subviews

    private var inputFieldsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            CLTextField(text: $taskName, state: .constant(.valid), showError: .constant(false), errorMessage: .constant(""), placeholder: "taskName".localized, keyboardType: .asciiCapable)

            CLTextField(text: $taskDescription, state: .constant(.valid), showError: .constant(false), errorMessage: .constant(""), placeholder: "taskDescription".localized, keyboardType: .asciiCapable)
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

    private var categoryView: some View {
        VStack(alignment: .leading) {

            CLTextField(text: $newCategory, state: .constant(.valid), showError: .constant(false), errorMessage: .constant(""), placeholder: "addOrSelectCategory".localized, keyboardType: .asciiCapable)
                .onSubmit {
                    if !newCategory.isEmpty {
                        dataManager.addTaskCategory(taskCategoryID: UUID(), categoryName: newCategory) { result in
                            switch result {
                            case .success:
                                category = dataManager.fetchTaskCategory(with: newCategory)?.first
                            case .failure:
                                showAppAlert(title: "error".localized, message: "somethingWentWrong".localized)
                            }
                            newCategory = ""
                        }
                    }
                }

            TagView(selectedCategory: $category)
        }
    }

    private var saveUpdateButton: some View {
        Button(action: saveTask) {
            HStack {
                Spacer()
                Text((isEditingTask ? "update".localized : "save".localized).uppercased())
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
                dataManager.updateTask(existingTask, withName: taskName, details: taskDescription, isStarred: isStarred, isNotifyOn: isNotifyOn, taskCategory: category) { result in
                    handleSaveUpdateResult(result)
                }
            } else {
                showAppAlert(title: "error".localized, message: "somethingWentWrong".localized)
            }
        } else {
            dataManager.addTask(taskID: taskID, taskName: taskName, taskDetails: taskDescription, isStarred: isStarred, isNotifyOn: isNotifyOn, taskCategory: category) { result in
                handleSaveUpdateResult(result)
            }
        }
    }


    // MARK: - Delete Task

    /// Deletes the task from the data manager.
    private func deleteTask(_ task: Task) {
        dataManager.deleteTask(task) { result in
            handleSaveUpdateResult(result)
        }
    }

    // MARK: - Validate Task Values

    private func validateTaskValues() -> Bool {
        guard !taskName.isEmpty else {
            showAppAlert(title: "error".localized, message: "somethingWentWrong".localized)
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
            showAppAlert(title: "error".localized, message: "somethingWentWrong".localized)
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
        NavigationView {
            TaskEditorView()
        }
    }
}
