//
//  Set+CoreDataProperties.swift
//  GymLog
//
//  Created by Вика on 8/14/22.
//
//

import Foundation
import CoreData


extension Set {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    @NSManaged public var weight: Int64
    @NSManaged public var reps: Int64
    @NSManaged public var workout: Workout?

}

extension Set : Identifiable {

}
