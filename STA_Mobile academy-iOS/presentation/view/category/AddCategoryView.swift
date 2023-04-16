//
//  AddCategoryView.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import SwiftUI

struct AddCategoryView: View {
    
    @Binding
    var addCategoryClicked: Bool
    
    @Environment(\.managedObjectContext)
    private var viewContext
    
    @EnvironmentObject
    var categoryViewModel: CategoryViewModel
    
    @FocusState
    private var focusedField: FocusedField?
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                VStack {
                    
                    Image("add-category")
                        .resizable()
                        .scaledToFit()
                    
                    TextField("Enter a name", text: $categoryViewModel.name)
                        .font(.title3)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.blue)
                        .focused($focusedField, equals: .categoryName)
                        .padding(.bottom)
                        .keyboardType(.webSearch)
                        .onSubmit(submit)
                    
                    Button(action: submit, label: {
                        Text("Save")
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
                focusedField = .categoryName
            }
            .navigationTitle("Add Category")
            
        }
        
    }
    
    // handle actions
    private func submit() {
        if (!categoryViewModel.name.trimAndRemoveSpaces(using: .whitespacesAndNewlines).isEmpty) {
            
            categoryViewModel.insert(context: viewContext)
            addCategoryClicked.toggle()
            
        }
    }
}
