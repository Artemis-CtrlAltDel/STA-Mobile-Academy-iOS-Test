//
//  CategoryViewModel.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import Foundation
import Combine
import CoreData

class CategoryViewModel: ObservableObject {
    
    @Published
    var name = ""
    
    func insert(context: NSManagedObjectContext) {
        let category = Category(context: context)
        
        category.name = name.trimAndRemoveSpaces(using: .whitespacesAndNewlines)
        category.createdAt = Date()
        
        save(context: context)
        
        name = ""
    }
    
    func delete(category: Category, context: NSManagedObjectContext) {
        context.delete(category)
        
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
