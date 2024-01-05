//
//  DataManager.swift
//  Tasks
//
//  Created by Chaitali Lad on 03/01/24.
//

import CoreData

/// Main data manager to handle the todo items
class DataManager: NSObject, ObservableObject {
    static let shared = DataManager()
    /// Dynamic properties that the UI will react to
    @Published var taskItems: [Task] = [Task]()

    /// Add the Core Data container with the model name
    let container: NSPersistentContainer = NSPersistentContainer(name: "Tasks")

    /// Default init method. Load the Core Data container
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
    }

    // MARK: - Core Data Operations

    /// Fetch tasks using a task ID
    /// - Parameter taskID: The ID of the task to fetch
    /// - Returns: A Result type indicating success with an array of tasks, or failure with an error
    func fetchTasks(with taskID: UUID) -> [Task]? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskID.description)

        do {
            let tasks = try container.viewContext.fetch(fetchRequest) as [Task]
            return tasks
        } catch {
            return nil
        }
    }

    /// Add a new task
    /// - Parameters:
    ///   - taskID: The ID of the new task
    ///   - taskName: The name of the new task
    ///   - taskDetails: The details of the new task
    ///   - isStarred: A boolean indicating whether the task is starred
    ///   - isNotifyOn: A boolean indicating whether notifications are enabled for the task
    ///   - completion: A completion handler with a Result type indicating success or failure
    func addTask(taskID: UUID, taskName: String, taskDetails: String, isStarred: Bool, isNotifyOn: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let newTask = Task(context: container.viewContext)
        newTask.id = taskID
        newTask.taskName = taskName
        newTask.taskDetails = taskDetails
        newTask.isStarred = isStarred
        newTask.isNotifyOn = isNotifyOn

        // Call the saveChanges function and pass the result to the completion handler
        completion(saveChanges())
    }

    /// Update an existing task
    /// - Parameters:
    ///   - task: The task to update
    ///   - taskName: The new name for the task
    ///   - taskDetails: The new details for the task
    ///   - isStarred: A boolean indicating whether the task is starred
    ///   - isNotifyOn: A boolean indicating whether notifications are enabled for the task
    ///   - completion: A completion handler with a Result type indicating success or failure
    func updateTask(_ task: Task, withName taskName: String, details taskDetails: String, isStarred: Bool, isNotifyOn: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        task.taskName = taskName
        task.taskDetails = taskDetails
        task.isStarred = isStarred
        task.isNotifyOn = isNotifyOn

        // Call the saveChanges function and pass the result to the completion handler
        completion(saveChanges())
    }

    /// Delete a task
    /// - Parameters:
    ///   - task: The task to delete
    ///   - completion: A completion handler with a Result type indicating success or failure
    func deleteTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void)  {
        container.viewContext.delete(task)

        // Call the saveChanges function and pass the result to the completion handler
        completion(saveChanges())
    }

    // MARK: - Save Changes

    /// Save changes to the Core Data context
    /// - Returns: A Result type indicating success or failure
    func saveChanges() -> Result<Void, Error> {
        do {
            try container.viewContext.save()
            return .success(())
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
