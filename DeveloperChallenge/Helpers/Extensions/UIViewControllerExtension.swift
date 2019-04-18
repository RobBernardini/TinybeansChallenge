//
//  UIViewControllerExtension.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/16/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Function used to display an alert to the user.
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Function used to display an alert from an Error.
    func showErrorAlert(_ error: Error) {
        showAlert(title: "", message: error.localizedDescription)
    }
}
