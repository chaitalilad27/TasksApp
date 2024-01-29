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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false), NSSortDescriptor(key: "isStarred", ascending: false)]) var taskItems: FetchedResults<Task>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "categoryName", ascending: true)]) var taskCategories: FetchedResults<TaskCategory>

    @State private var showCompletedTasks: Bool = false
    @State private var selectedCategory: String = ""

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                contentStack
            }
            .background(Color.white.ignoresSafeArea(.all))
            .navigationBarStyle(title: "tasks")
            .onAppear {
                if selectedCategory.isEmpty, !taskCategories.isEmpty {
                    selectedCategory = taskCategories[0].categoryName
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        authManager.signOut() { error in
                            if let e = error {
                                print(e.localizedDescription)
                            }
                        }
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        TaskEditorView(task: nil)
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private var contentStack: some View {
        VStack(spacing: 0) {
            if taskItems.isEmpty {
                emptyStateView
            } else {
                categoryListView

                TabView(selection: $selectedCategory) {
                    ForEach(taskCategories, id: \.self) { taskCategory in
                        taskList(taskCategory)
                            .tag(taskCategory.categoryName)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeIn, value: selectedCategory)
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
        .padding([.top, .horizontal], 10)
    }

    private var categoryListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(taskCategories, id: \.self) { taskCategory in
                    Text(taskCategory.categoryName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(selectedCategory == taskCategory.categoryName ? Color.appThemeColor: Color.gray.opacity(0.6))
                        .cornerRadius(.infinity)
                        .onTapGesture {
                            selectedCategory = taskCategory.categoryName
                        }
                        .tag(taskCategory.categoryName)
                }
            }
        }
    }

    private func getUncompletedTasks(_ taskCategory: TaskCategory) -> [Task] {
        return taskItems.filter { $0.category == taskCategory && !$0.isCompleted }
    }

    private func taskList(_ category: TaskCategory) -> some View {
        ScrollView {
            ForEach(getUncompletedTasks(category), id: \.self) { task in
                NavigationLink {
                    TaskEditorView(task: task)
                } label: {
                    TaskRowView(task: task)
                        .id(task.id)
                }
                .listRowSeparator(.hidden)
            }
            .listRowBackground(Color.white)

            if let completedTasks = taskItems.filter { $0.category == category && $0.isCompleted }, completedTasks.count > 0 {
                completedTasksSection(completedTasks)
            }
        }
        .padding(.top, 10)
    }

    private func completedTasksSection(_ tasks: [Task]) -> some View {
        Section(header: completedTasksSectionHeader(tasks.count)) {
            if showCompletedTasks {
                ForEach(tasks, id: \.self) { task in
                    NavigationLink {
                        TaskEditorView(task: task)
                    } label: {
                        TaskRowView(task: task)
                            .id(task.id)
                    }
                    .listRowSeparator(.hidden)
                }
                .listRowBackground(Color.white)
            }
        }
    }

    private func completedTasksSectionHeader(_ count: Int) -> some View {
        HStack {
            Text("completedTasks".localized + " (\(count))")
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

            Text("emptyStateMessage".localized)
                .font(.title2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
