//
//  CoreDataManager.swift
//  GymLog
//
//  Created by Вика on 8/17/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager{
    
    //паттерн одиночка
    static let shared = CoreDataManager()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: CRUD for WorkoutSets
    func addWorkoutSet(workout: Workout, weight: Int64, reps: Int64){
        let set: WorkoutSet = WorkoutSet(context: self.context)
        set.weight = weight
        set.reps = reps
        set.workout = workout
        
        save()
    }
    func fetchWorkoutSets()->[WorkoutSet]{
        var sets: [WorkoutSet] = []
        do {
            sets = try context.fetch(WorkoutSet.fetchRequest())
        }
        catch { }
        return sets
    }
    //получаем все workoutsets определенного workout'а
    func fetchWorkoutSets(workout: Workout)->[WorkoutSet]{
        var sets: [WorkoutSet] = []
        do {
            let request = WorkoutSet.fetchRequest() as NSFetchRequest<WorkoutSet>
            
            // TODO: написать предикат для того чтобы вытаскивать нужные объекты
            //let pred = NSPredicate(format: "", arguments: )
            //request.predicate = pred
            
            sets = try context.fetch(request)
        }
        catch { }
        return sets
    }
    func updateWorkoutSet(set: WorkoutSet, weight: Int64, reps: Int64){
        set.weight = weight
        set.reps = reps
        save()
    }

    //MARK: CRUD for Workouts
    func addWorkouts(exercises: [Exercise], date: Date){
        for ex in exercises{
            let workout: Workout = Workout(context: self.context)
            workout.exercise = ex
            workout.date = date
        }
        save()
    }
    func fetchWorkouts()->[Workout]{
        var workouts: [Workout] = []
        do {
            workouts = try context.fetch(Workout.fetchRequest())
        }
        catch { }
        return workouts
    }
    //получаем все workouts определенной даты
    func fetchWorkouts(date: Date)->[Workout]{
        var workouts: [Workout] = []
        do {
            let request = Workout.fetchRequest() as NSFetchRequest<Workout>
            
            // TODO: написать предикат для того чтобы вытаскивать объекты с нужной датой
            //let pred = NSPredicate(format: "", arguments: )
            //request.predicate = pred
            
            workouts = try context.fetch(request)
        }
        catch { }
        return workouts
    }
    
    //MARK: CRUD for Exercises
    func addExercise(name: String, type: Folder){
        let ex = Exercise(context: self.context)
        ex.name = name
        ex.folder = type
        
        save()
    }
    func fetchExercises()->[Exercise]{
        var exercises: [Exercise] = []
        do {
            exercises = try context.fetch(Exercise.fetchRequest())
        }
        catch { }
        return exercises
    }
    //получаем все exercises определенного типа
    func fetchExercises(type: Folder)->[Exercise]{
        var exercises: [Exercise] = []
        do {
            let request = Exercise.fetchRequest() as NSFetchRequest<Exercise>
            
            // TODO: написать предикат для того чтобы вытаскивать нужные объекты
            //let pred = NSPredicate(format: "", arguments: )
            //request.predicate = pred
            
            exercises = try context.fetch(request)
        }
        catch { }
        return exercises
    }
    func updateExercise(ex: Exercise, newname: String){
        ex.name = newname
        save()
    }
    
    //MARK: CRUD for Folders
    func addFolder(name: String){
        let type: Folder = Folder(context: self.context)
        type.name = name
        save()
    }
    func fetchFolders()->[Folder]{
        var typesofex: [Folder] = []
        do {
            typesofex = try context.fetch(Folder.fetchRequest())
        }
        catch { }
        return typesofex
    }
    func updateFolder(folder: Folder, newname: String){
        folder.name = newname
        save()
    }
    
    //MARK: delete any object
    func delete(obj: NSManagedObject){
        context.delete(obj)
        save()
    }
    
    //MARK: save all updates
    private func save(){
        do {
            try self.context.save()
        }
        catch { }
    }
}
