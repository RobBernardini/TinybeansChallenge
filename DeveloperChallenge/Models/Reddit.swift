//
//  RedditModel.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/17/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation

// Reddit Protocol used so that the initial saved data and fetched
// API data can be saved in Core Data in a clear manner.
protocol Reddit {
    var redditIdentifier: String { get }
    var redditAuthor: String { get }
    var redditMessage: String { get }
    var redditScore: Int { get }
    var redditDate: Date { get }
}

// Reddit Model used to initialise the initial store data.
// This conforms to the Reddit protocol so that it can be saved
// in Core Data.
struct RedditModel: Reddit {
    var redditIdentifier: String
    var redditAuthor: String
    var redditMessage: String
    var redditScore: Int
    var redditDate: Date
    
    init(id: String, message: String, author: String, score: Int, date: Date = Date()) {
        self.redditIdentifier = id
        self.redditAuthor = author
        self.redditMessage = message
        self.redditScore = score
        self.redditDate = date
    }
}
