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
    
    @Published
    var content = ""
    
    @Published
    var remindAt = Date()
    
    @Published
    var canRemind = false
    
    func insert(category: Category, context: NSManagedObjectContext) {
        let todo = Todo(context: context)
        
        todo.id = UUID()
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
    
    func markAsDone(todo: Todo, context: NSManagedObjectContext) {
        todo.isDone.toggle()
        
        save(context: context)
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
