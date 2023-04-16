//
//  ContentView.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext)
    private var viewContext
    
    @EnvironmentObject
    var categoryViewModel: CategoryViewModel
    
    @State
    private var addCategoryClicked = false
    
    @State
    private var emptySource: EmptySource = .emptyCategories
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
    var categoryList: FetchedResults<Category>
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                if (categoryList.isEmpty) {
                    EmptyView(emptySource: $emptySource)
                } else {
                    
                    List(categoryList) { category in
                        
                        NavigationLink(destination: TodoView(category: category)) {
                            
                            HStack {
                                
                                VStack {
                                    Text(category.todo?.count.formatted() ?? "0")
                                        .font(.footnote)
                                        .bold()
                                        .padding(7)
                                        .foregroundColor(.white)
                                        .background(.blue)
                                        .clipShape(Circle())
                                }
                                .padding(.trailing)
                                
                                VStack {
                                    Text(category.name ?? "")
                                        .foregroundColor(.primary)
                                        .font(.title2)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(category.createdAt?.formatted() ?? "")
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive, action: {
                                    categoryViewModel.delete(category: category, context: viewContext)
                                }, label: {
                                    Image(systemName: "trash")
                                })
                            }
                            
                        }
                        
                    }
                    
                }
            }
            .navigationTitle("Welcome")
            .sheet(isPresented: $addCategoryClicked, content: {
                AddCategoryView(addCategoryClicked: $addCategoryClicked)
            })
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        addCategoryClicked.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    })
                }
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
