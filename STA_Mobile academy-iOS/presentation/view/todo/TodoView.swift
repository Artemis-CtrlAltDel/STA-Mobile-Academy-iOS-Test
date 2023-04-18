//
//  TodoView.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import SwiftUI

struct TodoView: View {

    var category: Category
    
    private var fetchRequest: FetchRequest<Todo>
    private var todoList: FetchedResults<Todo> {
        fetchRequest.wrappedValue
    }
    
    init(category: Category) {
        self.category = category
        
        fetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(key: "remindAt", ascending: true)],
            predicate: NSPredicate(
                format: "category.id == %@",
                UUID(uuid: category.id?.uuid ?? UUID().uuid) as CVarArg
            )
        )
    }
    
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
                
                if todoList.isEmpty {
                    EmptyView(emptySource: $emptySource)
                } else {
                    
                    List(todoList) { todo in
                        
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
                            
                            Image(systemName: todo.canRemind && !todo.isExpired() ? "bell.and.waves.left.and.right.fill" : "")
                                .foregroundColor(.yellow)
                            
                        }
                        .strikethrough(todo.isExpired(), color: .green)
                        .opacity(todo.isExpired() ? 0.5 : 1)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive, action: {
                                todoViewModel.delete(todo: todo, context: viewContext)
                            }, label: {
                                Image(systemName: "trash")
                            })
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(action: {
                                todoViewModel.markAsDone(todo: todo, context: viewContext)
                            }, label: {
                                todo.isDone ? Image(systemName: "minus.rectangle.portrait") : Image(systemName: "checkmark.rectangle.portrait")
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
                        Image(systemName: "plus")
                            .imageScale(.large)
                    })
                }
            }
            
        }
        
    }
    
}
