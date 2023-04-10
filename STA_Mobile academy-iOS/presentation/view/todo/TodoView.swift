//
//  TodoView.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import SwiftUI

struct TodoView: View {
    
    var category: Category
    
    @Environment(\.managedObjectContext)
    private var viewContext
    
    @EnvironmentObject
    var todoViewModel: TodoViewModel
    
    @State
    private var addTodoClicked = false
    
    @State
    private var emptySource: EmptySource = .emptytodos
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if (category.todo?.allObjects as! [Todo]).isEmpty {
                    EmptyView(emptySource: $emptySource)
                } else {
                    
                    List(category.todo?.allObjects as! [Todo]) { todo in
                        
                        HStack {
                            
                            VStack {
                                Text(todo.content ?? "")
                                    .foregroundColor(.primary)
                                    .font(.title2)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(todo.remindAt?.formatted() ?? "")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Image(systemName: todo.canRemind && !todo.isDisabled() ? "bell.and.waves.left.and.right.fill" : "")
                                .foregroundColor(.yellow)
                            
                        }
                        .strikethrough(todo.isDisabled(), color: .green)
                        .opacity(todo.isDisabled() ? 0.5 : 1)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive, action: {
                                todoViewModel.delete(todo: todo, context: viewContext)
                            }, label: {
                                Label("", systemImage: "trash")
                            })
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(action: {
                                todoViewModel.markAsDone(todo: todo, context: viewContext)
                            }, label: {
                                todo.isDone ? Label("", systemImage: "minus.rectangle.portrait") : Label("", systemImage: "checkmark.rectangle.portrait")
                            })
                            .tint(todo.isDone ? .orange : .green)
                            
                        }
                        
                    }
                    
                }
                
            }
            .navigationTitle("\(category.name ?? "") Todos".trimAndRemoveSpaces(using: .whitespacesAndNewlines))
            .sheet(isPresented: $addTodoClicked, content: {
                AddTodoView(category: category, addTodoClicked: $addTodoClicked)
            })
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        addTodoClicked.toggle()
                    }, label: {
                        Label("", systemImage: "plus")
                            .imageScale(.large)
                    })
                }
            }
            
        }
        
    }
    
}
