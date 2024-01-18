//
//  HomeView.swift
//  Tasks
//
//  Created by Chaitali Lad on 02/01/24.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Properties
    @EnvironmentObject var authManager: AuthManager
    @FetchRequest(sortDescriptors: []) var taskItems: FetchedResults<Task>
    @State private var taskToEdit: Task?
    @State private var isAddingTask: Bool = false
    @State private var showCompletedTasks: Bool = false

    private var unCompletedTasks: [Task] {
        taskItems.filter { !$0.isCompleted }
    }

    private var completedTasks: [Task] {
        taskItems.filter { $0.isCompleted }
    }

    private var completedTasksCount: Int {
        return completedTasks.count
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                contentStack
                floatingButtonView
            }
            .background(Color.white.ignoresSafeArea(.all))
            .navigationBarStyle(title: "tasks")
            .sheet(isPresented: $isAddingTask) {
                taskEditorView(task: nil)
            }
            .sheet(item: $taskToEdit) { task in
                taskEditorView(task: task)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log out") {
                        print("Log out tapped!")
                        authManager.signOut() { error in

                            if let e = error {
                                print(e.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private var contentStack: some View {
        VStack {
            if taskItems.isEmpty {
                emptyStateView
            } else {
                taskList
            }
        }
    }

    private var taskList: some View {
        List {
            ForEach(unCompletedTasks, id: \.self) { task in
                TaskRowView(task: task)
                    .onTapGesture {
                        taskToEdit = task
                    }
            }
            .listRowBackground(Color.white)

            if completedTasksCount > 0 {
                completedTasksSection
            }
        }
        .listStyle(PlainListStyle())
    }

    private var completedTasksSection: some View {
        Section(header: completedTasksSectionHeader) {
            if showCompletedTasks {
                ForEach(completedTasks, id: \.self) { task in
                    TaskRowView(task: task)
                        .onTapGesture {
                            taskToEdit = task
                        }
                }
                .listRowBackground(Color.white)
            }
        }
    }

    private var completedTasksSectionHeader: some View {
        HStack {
            Text(NSLocalizedString("completedTasks", comment: "") + " (\(completedTasksCount))")
            Spacer()
            ToggleImageView(selectedImageName: "chevron.up", unSelectedImageName: "chevron.down", size: CGSize(width: 15, height: 10), selectedImageColor: .gray, unSelectedImageColor: .gray, isSelected: $showCompletedTasks) { }
        }
        .onTapGesture { showCompletedTasks.toggle() }
    }

    private var emptyStateView: some View {
        Group {
            Spacer()

            Image("emptyState")
                .resizable()
                .frame(width: 200, height: 200)

            Text(NSLocalizedString("emptyStateMessage", comment: ""))
                .font(.title2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Spacer()
        }
    }

    private var floatingButtonView: some View {
        HStack {
            Spacer()

            FloatingButton(systemImageName: "plus") {
                isAddingTask = true
            }
        }
    }

    private func taskEditorView(task: Task?) -> some View {
        TaskEditorView(task: task)
            .presentationDetents([.height(350)])
            .presentationDragIndicator(.visible)
            .onDisappear {
                isAddingTask = false
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
