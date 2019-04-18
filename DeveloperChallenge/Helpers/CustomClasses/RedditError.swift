//
//  RedditError.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/17/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation

enum RedditError: Error {
    case invalidURL
    case unzippingFileFailed
}

extension RedditError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is invalid."
        case .unzippingFileFailed:
            return "Failed to unzip data. Please try again."
        }
    }
}
