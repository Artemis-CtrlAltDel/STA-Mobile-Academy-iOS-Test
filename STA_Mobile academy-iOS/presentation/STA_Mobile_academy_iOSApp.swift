//
//  STA_Mobile_academy_iOSApp.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import SwiftUI

@main
struct STA_Mobile_academy_iOSApp: App {
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
        
    @StateObject
    var categoryViewModel = CategoryViewModel()
    
    @StateObject
    var todoViewModel = TodoViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .environmentObject(categoryViewModel)
                .environmentObject(todoViewModel)
        }
    }
}
