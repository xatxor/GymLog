//
//  TypeOfExercise+CoreDataProperties.swift
//  GymLog
//
//  Created by Вика on 8/14/22.
//
//

import Foundation
import CoreData


extension TypeOfExercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TypeOfExercise> {
        return NSFetchRequest<TypeOfExercise>(entityName: "TypeOfExercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension TypeOfExercise {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: Exercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: Exercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension TypeOfExercise : Identifiable {

}
