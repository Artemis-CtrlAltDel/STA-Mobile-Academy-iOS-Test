//
//  TodoViewModel.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import Foundation
import Combine
import CoreData

class TodoViewModel: ObservableObject {
    
    let notifyUtils = NotificationUtils()
    
    @Published
    var content = ""
    
    @Published
    var remindAt = Date()
    
    @Published
    var canRemind = false
    
    func insert(category: Category, context: NSManagedObjectContext) {
        let todo = Todo(context: context)
        
        todo.content = content
        todo.remindAt = remindAt
        todo.canRemind = canRemind
        todo.createdAt = Date()
        todo.category = category
        
        save(context: context)
        
        content = ""
        remindAt = Date()
        canRemind = false
    }
    
    func delete(todo: Todo, context: NSManagedObjectContext) {
        context.delete(todo)
        
        save(context: context)
    }
    
    // TODO fix
    func markAsDone(todo: Todo, context: NSManagedObjectContext) {
        todo.isDone.toggle()
        
        save(context: context)
    }
    
    // TODO fix
    func notify(category: Category, todo: Todo) {
        if !canRemind || !notifyUtils.checkPermissions() {
            return
        }
        
        NotificationUtils().createNotification(
            date: todo.remindAt ?? Date(),
            title: category.name ?? "",
            body: todo.content ?? ""
        )
    }
    
    private func save(context:NSManagedObjectContext){
        do{
            try context.save()
        }
        catch{
            print(error)
        }
    }
    
}
