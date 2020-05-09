//
//  CoreDataService.swift
//  BestLife
//
//  Created by Mike Griffin on 4/2/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func clearEverything() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }
    
    func saveCategory(name: String, color: String) {
        let newCategory = Category(context: context)
        newCategory.hex = color
        newCategory.name = name
        newCategory.id = UUID()
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func loadCategories() -> [Category]{
        var categories = [Category]()
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)

        } catch {
            print("Error fetching category from context \(error)")
        }
        
        return categories
    }
    
    func saveActivity(name: String, color: String, category: Category?) {
        let newActivity = Activity(context: context)
        newActivity.hex = color
        newActivity.name = name
        newActivity.id = UUID()
        newActivity.category = category
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func loadActivities() -> [Activity] {
        var activities = [Activity]()
        let request : NSFetchRequest<Activity> = Activity.fetchRequest()
        do {
            activities = try context.fetch(request)

        } catch {
            print("Error fetching activity from context \(error)")
        }
        return activities
    }
    
    func loadActivitySplitByCategory() -> [Category: [Activity]] {
        var activityCategoryDictionary = [Category : [Activity]]()
        let activities = loadActivities()
        for activity in activities {
            if let category = activity.category {
                if(!activityCategoryDictionary.contains(where: {
                    $0.key == activity.category
                })) {
                    activityCategoryDictionary[category] = activities.filter({$0.category == activity.category})
                    }
                }
        }
        return activityCategoryDictionary
    }
    
    func loadSingleCategoryActivities(_ category: Category) -> [Activity] {
        print(category)
        var activities = [Activity]()
        let predicate = NSPredicate(format: "category == %@", category)
        let request : NSFetchRequest<Activity> = Activity.fetchRequest()
        request.predicate = predicate
        do {
            activities = try context.fetch(request)
        } catch {
            print("Error fetching activities for category")
        }
        
        return activities
    }
    
    func loadCategory(id: UUID) -> Category? {
        var category : Category?
        let predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = predicate
        do {
            category = try context.fetch(request).first
            return category
        } catch {
            print("Error fetching category by id \(error)")
            return nil
        }
    }
    
    func saveStreakGoal(duration: Int, timespan: String, habit: Habit) {
        saveGoal(duration: duration, timeSpan: timespan, habit: habit, deadline: nil)
    }
    
    func saveDeadlineGoal(deadline: Date, habit: Habit) {
        saveGoal(duration: nil, timeSpan: nil, habit: habit, deadline: deadline)
    }
    
    fileprivate func saveGoal(duration: Int?, timeSpan: String?, habit: Habit, deadline: Date?) {
        let logMoment = Date()
        let completed = false
        let progress : Float = 0.0
        let newGoal = Goal(context: context)
        if let category = habit as? Category {
            newGoal.category = category
        }
        if let activity = habit as? Activity {
            newGoal.activity = activity
        }
        newGoal.id = UUID()
        newGoal.completed = completed
        newGoal.progress = progress
        newGoal.logMoment = logMoment
        newGoal.deadline = deadline
        if let duration = duration {
            newGoal.duration = Int16(duration)
        }
        newGoal.timeSpan = timeSpan
        do {
            try context.save()
        } catch {
            print("Error saving goal \(error)")
        }
    }
    
    func loadFutureGoals() -> [Goal]? {
        var goals : [Goal]?
        goals = loadFutureDeadlineGoals()
        if var goals = goals {
            if let streakGoals = loadStreakGoals() {
                for goal in streakGoals {
                    goals.append(goal)
                }
            }
            return goals
        }
        else {
            goals = loadStreakGoals()
        }
        return goals
    }
    
    fileprivate func loadStreakGoals() -> [Goal]? {
        var goals : [Goal]
        let predicate = NSPredicate(format: "timeSpan != nil")
        let request : NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = predicate
        
        do {
            goals = try context.fetch(request)
            for goal in goals {
                if goal.currentStreakDeadline == nil {
                    goal.currentStreakDeadline = calculateInitialStreakDeadline(goal)
                }
            }
            return goals
        } catch {
            print("Error fetching streak goals \(error)")
            return nil
        }
    }
    
    fileprivate func loadFutureDeadlineGoals() -> [Goal]? {
        let futureDeadlinePredicate = NSPredicate(format: "%@ >= %@", "deadline", Date().startOfDay() as CVarArg)
        let deadlineNotNilPredicate = NSPredicate(format: "deadline != nil")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [futureDeadlinePredicate, deadlineNotNilPredicate])

        var goals : [Goal]
        let request : NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = compoundPredicate
        do {
            goals = try context.fetch(request)

            return goals
        } catch {
            print("Error fetching future deadline goals \(error)")
            return nil
        }
    }
    
    fileprivate func calculateInitialStreakDeadline(_ goal: Goal) -> Date {
        let calendarSpan = getCalendarSpanFromGoalSpan(goal)
        return calculateStreakDeadline(quantity: Int(goal.duration), calendarSpan: calendarSpan)
    }
    
    func calculateStreakDeadline(quantity: Int, calendarSpan: Calendar.Component) -> Date {
        return Date().startOfDay().addCalendarSpanValue(quantity: quantity, calendarSpan: calendarSpan)
    }
    
    func getCalendarSpanFromGoalSpan(_ goal: Goal) -> Calendar.Component{
        switch(goal.timeSpan!) {
            case TimeSpan.Days.rawValue:
                return .day
        case TimeSpan.Weeks.rawValue:
            return .weekOfYear
        case TimeSpan.Months.rawValue:
            return .month
        default:
            return .day
        }
    }
    
    func loadGoals() -> [Goal]{
        var goals = [Goal]()
        let request : NSFetchRequest<Goal> = Goal.fetchRequest()
        do {
            goals = try context.fetch(request)
        } catch {
            print("Error fetching category from context \(error)")
        }
        
        return goals
    }
    
    func saveEvent(activity: Activity, startTime: Date?, endTime: Date?, duration: Int?) {
        updateGoals(activity: activity)
        let newEvent = Event(context: context)
        newEvent.activity = activity
        if let duration = duration {
            newEvent.duration = Int64(duration)
        }
        newEvent.startTime = startTime
        newEvent.endTime = endTime
        newEvent.logMoment = Date()
        do {
            try context.save()
        } catch {
            print("Error saving event \(error)")
        }
    }
    
    func loadEvents() -> [Event]? {
        var events = [Event]()
        let request : NSFetchRequest<Event> = Event.fetchRequest()
        do {
            events = try context.fetch(request)
            
            for event in events {
                print("EVENT ACTIVITY \(event.activity?.name!)")
            }
        } catch {
            print("Error fetching events from context \(error)")
        }
        
        return events
    }
    
    fileprivate func updateGoals(activity: Activity) {
        let goals = activity.goals?.allObjects as! [Goal]
            for goal in goals {
                if goal.deadline != nil {
                    checkDeadlineProgress(goal)
                }
                else if goal.currentStreakDeadline != nil {
                    updateCurrentStreakDeadline(goal)
                }
        }
        
        if let category = activity.category {
            let categoryGoals = category.goals?.allObjects as! [Goal]
            for goal in categoryGoals {
                if goal.deadline != nil {
                    checkDeadlineProgress(goal)
                }
                else if goal.currentStreakDeadline != nil {
                    updateCurrentStreakDeadline(goal)
                }
            }
            
        }
    }
    
    fileprivate func checkDeadlineProgress(_ goal: Goal) {
        print("checking the deadline progress...")
    }
    
    fileprivate func updateCurrentStreakDeadline(_ goal: Goal) {
        let predicate = NSPredicate(format: "%K == %@", "id", goal.id! as CVarArg)
        let request : NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = predicate
        do {
            let goalUpdate = try context.fetch(request).first
            let currentStreakDeadline = calculateInitialStreakDeadline(goal)
            goalUpdate?.setValue(currentStreakDeadline, forKey: "currentStreakDeadline")
            do {
                try context.save()
            }
            catch {
                print("Error saving the updated goal \(error)")
            }
        } catch {
            print("Error fetching goal by id \(error)")
        }
    }
}
