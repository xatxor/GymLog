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
    
    // TODO: добавить обработчики ошибок
    
    //паттерн одиночка
    static let shared = CoreDataManager()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: CRUD for WorkoutSets
    func addWorkoutSet(workout: Workout){
        let set: WorkoutSet = WorkoutSet(context: self.context)
        set.weight = 0
        set.reps = 0
        set.workout = workout
        
        save()
    }
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
            
            let pred = NSPredicate(format: "workout == %@", workout)
            request.predicate = pred
            
            sets = try context.fetch(request)
        }
        catch { }
        return sets
    }
    func updateWorkoutSet(set: WorkoutSet, weight: Int, reps: Int){
        set.weight = Int64(weight)
        set.reps = Int64(reps)
        save()
    }

    //MARK: CRUD for Workouts
    func addWorkouts(exercises: [Exercise], date: Date){
        for ex in exercises{
            let workout: Workout = Workout(context: self.context)
            workout.exercise = ex
            workout.date = date
            
            save()
        }
    }
    func fetchWorkouts()->[Workout]{
        var workouts: [Workout] = []
        do {
            workouts = try context.fetch(Workout.fetchRequest())
        }
        catch { }
        return workouts
    }
    func fetchWorkouts(exercise: Exercise)->[Workout]{
        var workouts: [Workout] = []
        do {
            let request = Workout.fetchRequest() as NSFetchRequest<Workout>
            
            let pred = NSPredicate(format: "exercise == %@", exercise)
            request.predicate = pred
            
            workouts = try context.fetch(request)
        }
        catch { }
        return workouts
    }
    func fetchWorkoutsSorted(exercise: Exercise)->[Workout]{
        var workouts: [Workout] = []
        do {
            let request = Workout.fetchRequest() as NSFetchRequest<Workout>
            
            let pred = NSPredicate(format: "exercise == %@", exercise)
            let sort = NSSortDescriptor(key: #keyPath(Workout.date), ascending: false)
            
            request.predicate = pred
            request.sortDescriptors = [sort]
            
            workouts = try context.fetch(request)
        }
        catch { }
        return workouts
    }
    //получаем все workouts определенной даты
    func fetchWorkouts(date: Date)->[Workout]{
        var workouts: [Workout] = []
        do {
            let request = Workout.fetchRequest() as NSFetchRequest<Workout>
            
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            
            let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
            
            let pred = NSPredicate(format: "date >= %@ AND date < %@", dateFrom as NSDate, dateTo! as NSDate)
            
            request.predicate = pred
            
            workouts = try context.fetch(request)
        }
        catch { }
        return workouts
    }
    
    //MARK: CRUD for Exercises
    func addExercise(name: String, folder: Folder)->Exercise{
        let ex = Exercise(context: self.context)
        ex.name = name
        ex.folder = folder
        
        save()
        return ex
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
    func fetchExercises(folder: Folder)->[Exercise]{
        var exercises: [Exercise] = []
        do {
            let request = Exercise.fetchRequest() as NSFetchRequest<Exercise>
            
            let pred = NSPredicate(format: "folder == %@", folder)
            request.predicate = pred
            
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
    func addFolder(name: String)->Folder{
        let folder: Folder = Folder(context: self.context)
        folder.name = name
        save()
        
        return folder
    }
    func fetchFolders()->[Folder]{
        var folder: [Folder] = []
        do {
            folder = try context.fetch(Folder.fetchRequest())
        }
        catch { }
        return folder
    }
    func updateFolder(folder: Folder, newname: String){
        folder.name = newname
        save()
    }
    
    //MARK: delete functions
    func delete(obj: NSManagedObject){
        context.delete(obj)
        save()
    }
    
    func delete(array: [NSManagedObject]){
        for item in array{
            delete(obj: item)
        }
    }
    
    func deleteAll(){
        let folders = fetchFolders()
        delete(array: folders)
        
        let exercises = fetchExercises()
        delete(array: exercises)
        
        let workouts = fetchWorkouts()
        delete(array: workouts)
        
        let sets = fetchWorkoutSets()
        delete(array: sets)
    }
    
    func deleteExercisesWithFolder(folder: Folder){
        let exercises = fetchExercises(folder: folder)
        delete(array: exercises)
    }
    
    func deleteWorkoutsWithExercise(exercise: Exercise){
        let workouts = fetchWorkouts(exercise: exercise)
        delete(array: workouts)
    }
    
    func deleteSetsWithWorkout(workout: Workout){
        let sets = fetchWorkoutSets(workout: workout)
        delete(array: sets)
    }
    
    //MARK: save all updates
    private func save(){
        do {
            try self.context.save()
        }
        catch { }
    }
    
    func addDefaultData(){
        var exercises: [String]
        var folder: Folder
        
        folder = addFolder(name: "Руки")
        exercises = ["Разведение гантелей стоя", "Разгибание рук из-за головы","Жим гантелей стоя", "Подъем на бицепс", "Тяга гантелей к подбородку"]
        for ex in exercises{ addExercise(name: ex, folder: folder) }
        
        folder = addFolder(name: "Ноги")
        exercises = ["Приседания", "Выпады", "Жим ногами в тренажере", "Сведение ног в тренажере", "Разведение ног в тренажере"]
        for ex in exercises{ addExercise(name: ex, folder: folder) }
        
        folder = addFolder(name: "Грудь")
        exercises = ["Жим лежа", "Отжимания","Отжимания на брусьях", "Сведение рук в тренажере", "Жим сидя в тренажере"]
        for ex in exercises{ addExercise(name: ex, folder: folder) }
        
        folder = addFolder(name: "Спина")
        exercises = ["Тяга верхнего блока", "Тяга нижнего блока", "Тяга штанги в наклоне", "Подтягивания", "Гиперэкстензия"]
        for ex in exercises{ addExercise(name: ex, folder: folder) }
        
        folder = addFolder(name: "Пресс")
        exercises = ["Скручивания", "Косые скручивания","Подъемы ног", "Велосипед", "Ножницы"]
        for ex in exercises{ addExercise(name: ex, folder: folder) }
    }
}
