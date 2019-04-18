//
//  RedditEntityExtension.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/16/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation
import CoreData

// Extension of the Core Data Reddit Entity so that each entity
// can be updated with data from the Reddit conforming models.
extension RedditEntity {
    
    func update(with reddit: Reddit) {
        identifier = reddit.redditIdentifier
        author = reddit.redditAuthor
        message = reddit.redditMessage
        date = reddit.redditDate
        score = Int32(reddit.redditScore)
    }
}

// Here the Reddit Entity is conformed to the Reddit Displayable Protocol
// so that the data can be displayed in the table view cell.
extension RedditEntity: RedditDisplayable {
    var redditAuthor: String {
        return author ?? ""
    }
    
    var redditMessage: String {
        return message ?? ""
    }
    
    var redditScore: String {
        return "\(score)"
    }
}
