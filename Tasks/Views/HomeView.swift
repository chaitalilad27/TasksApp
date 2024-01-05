//
//  HomeView.swift
//  Tasks
//
//  Created by Chaitali Lad on 02/01/24.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Properties

    @FetchRequest(sortDescriptors: []) var taskItems: FetchedResults<Task>
    @State private var taskToEdit: Task?
    @State private var isAddingTask: Bool = false

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
            ForEach(taskItems, id: \.self) { task in
                TaskRowView(task: task)
                    .onTapGesture {
                        taskToEdit = task
                    }
            }
            .listRowBackground(Color.white)
        }
        .listStyle(PlainListStyle())
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
