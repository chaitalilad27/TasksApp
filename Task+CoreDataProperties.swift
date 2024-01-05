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
    @NSManaged public var isStarred: Bool
    @NSManaged public var isNotifyOn: Bool

    // Add a convenience initializer
    convenience init(id: UUID, taskName: String, taskDetails: String, isStarred: Bool, isNotifyOn: Bool) {
        self.init(context: DataManager().container.viewContext)
        self.id = id
        self.taskName = taskName
        self.taskDetails = taskDetails
        self.isStarred = isStarred
        self.isNotifyOn = isNotifyOn
    }
}

extension Task : Identifiable {

}
