//
//  SimpleAlert.swift
//  LocaPlace
//
//  Created by KODDER on 09.09.2023.
//

import UIKit

extension UIViewController {
    
    func showLocationServicesDeniedAlert(_ title: String, message: String?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

