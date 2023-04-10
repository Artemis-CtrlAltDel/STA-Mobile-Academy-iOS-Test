//
//  AddTodoView.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import SwiftUI

struct AddTodoView: View {
    
    var category: Category
    
    private let notifyUtils = NotificationUtils()
    
    @Binding
    var addTodoClicked: Bool
    
    @Environment(\.managedObjectContext)
    private var viewContext
    
    @EnvironmentObject
    var todoViewModel: TodoViewModel
    
    @FocusState
    private var focusedField: FocusedField?
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                VStack {
                    
                    Image("add-todo")
                        .resizable()
                        .scaledToFit()
                    
                    HStack {
                        
                        DatePicker("", selection: $todoViewModel.remindAt, in: Date.now..., displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: todoViewModel.canRemind ? "bell.and.waves.left.and.right.fill" : "bell")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                notifyUtils.checkPermissions()
                                
                                if notifyUtils.isPermitted {
                                    todoViewModel.canRemind.toggle()
                                }
                            }
                        
                    }
                    
                    TextField("what are you up to", text: $todoViewModel.content)
                        .font(.title3)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.blue)
                        .focused($focusedField, equals: .todoContent)
                        .padding(.bottom)
                        .keyboardType(.webSearch)
                        .onSubmit(submit)
                    
                    Button(action: submit, label: {
                        Text("Save")
                            .bold()
                    })
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    
                }
                .padding(.top)
                .padding(.bottom)
                
            }
            .onAppear{
                focusedField = .todoContent
            }
            .navigationTitle("Add Todo")
            
        }
        
    }
    
    // handle actions
    private func submit() {
        if (!todoViewModel.content.trimAndRemoveSpaces(using: .whitespacesAndNewlines).isEmpty) {
            
            notify(category: category)
            todoViewModel.insert(category: category,context: viewContext)
            addTodoClicked.toggle()
            
        }
    }
    
    func notify(category: Category) {
        if !todoViewModel.canRemind || !notifyUtils.isPermitted {
            return
        }
        
        NotificationUtils().createNotification(
            date: todoViewModel.remindAt,
            title: category.name!,
            body: todoViewModel.content
        )
    }
    
}
