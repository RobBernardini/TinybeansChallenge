//
//  RedditTableViewCell.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/17/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import UIKit

// Reddit Displayable Protocol
// This protocol is to be conformed to by the Reddit Entity (Core Data) model so
// that only the required data is passed to the UI.
protocol RedditDisplayable {
    var redditAuthor: String { get }
    var redditMessage: String { get }
    var redditScore: String { get }
}

// This class is used to update the Table View Cell UI from the data passed
// to the cell that conforms to the Reddit Displayable protocol.
class RedditTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    var data: RedditDisplayable? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        guard let data = data else {
            return
        }
        messageLabel.text = data.redditMessage
        authorLabel.text = data.redditAuthor
        scoreLabel.text = "Score: \(data.redditScore)"
    }
}
