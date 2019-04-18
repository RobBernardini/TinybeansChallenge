//
//  APIModels.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/18/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation

// These API Models all conform to the Codable protocol and are
// used to help decode the API JSON data fetched from the backend.
struct APIModel: Codable {
    let data: ChildrenAPIModel
}

struct ChildrenAPIModel: Codable {
    let children: [ChildAPIModel]
}

struct ChildAPIModel: Codable {
    let reddit: RedditAPIModel
}

extension ChildAPIModel {
    enum CodingKeys: String, CodingKey {
        case reddit = "data"
    }
}

// Reddit API Model that conforms to the Codable and Hashable protocols
// so that the Reddit Article JSON can be decoded and the model parsed
// to remove any duplicates before being saved in Core Data.
struct RedditAPIModel: Codable, Hashable {
    let identifier: String?
    let author: String?
    let message: String?
    let score: Int?
    let date: Int?
}

extension RedditAPIModel {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case author
        case message = "selftext"
        case score
        case date = "created"
    }
}

// Here the Reddit API Model is conformed to the Reddit protocol so that it can be saved
// in Core Data.
extension RedditAPIModel: Reddit {
    var redditIdentifier: String {
        return identifier ?? ""
    }
    
    var redditAuthor: String {
        return author ?? ""
    }
    
    var redditMessage: String {
        return message ?? ""
    }
    
    var redditScore: Int {
        return score ?? 0
    }
    
    var redditDate: Date {
        guard let timeInterval = date else {
            return Date()
        }
        return Date(timeIntervalSince1970: TimeInterval(timeInterval))
    }
}

