
//
//  ArrayExtension.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/18/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation

extension Array where Element: Reddit {
    
    // Mutating function that removes any duplicate Reddit articles from the array
    // using the unique "identifier" to detect duplicate articles.
    mutating func removeDuplicates() {
        var result: [Element] = []
        for value in self {
            if result.filter({ $0.redditIdentifier == value.redditIdentifier }).first == nil {
                result.append(value)
            }
        }
        self = result
    }
}

