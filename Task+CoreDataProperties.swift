//
//  Task+CoreDataProperties.swift
//  Tasks
//
//  Created by Chaitali Lad on 03/01/24.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID
    @NSManaged public var taskName: String
    @NSManaged public var taskDetails: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isStarred: Bool
    @NSManaged public var isNotifyOn: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var category: TaskCategory?

    // Add a convenience initializer
    convenience init(id: UUID, taskName: String, taskDetails: String, isCompleted: Bool = false, isStarred: Bool, isNotifyOn: Bool, createdAt: Date = Date(), taskCategory: TaskCategory) {
        self.init(context: DataManager().container.viewContext)
        self.id = id
        self.taskName = taskName
        self.taskDetails = taskDetails
        self.isCompleted = isCompleted
        self.isStarred = isStarred
        self.isNotifyOn = isNotifyOn
        self.createdAt = createdAt
        self.updatedAt = createdAt
        self.category = taskCategory
    }
}

extension Task : Identifiable {

}
