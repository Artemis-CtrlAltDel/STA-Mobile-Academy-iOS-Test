//
//  XUtils.swift
//  STA_Mobile academy-iOS
//
//  Created by Bellaala Mohamed on 7/4/2023.
//

import Foundation

extension String {
    
    func trimAndRemoveSpaces(using characterSet: CharacterSet) -> String {
        return trimmingCharacters(in: characterSet)
            .split(separator: " ")
            .filter { $0 != " " }
            .joined(separator: " ")
    }
}

extension Todo {
    
    func isExpired() -> Bool {
        return self.isDone || (self.remindAt ?? Date()) < Date()
    }
}
