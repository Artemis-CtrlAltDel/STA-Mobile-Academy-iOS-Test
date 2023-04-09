//
//  EmptyView.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import SwiftUI

struct EmptyView: View {
    
    @Binding
    var emptySource: EmptySource
    
    var body: some View {
        
        NavigationView {
            VStack {
                Image("no-data")
                    .resizable()
                    .scaledToFit()
                Text("No \(emptySource.rawValue) found.")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                Text("Click on the icon below to add one")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
        
    }
}
