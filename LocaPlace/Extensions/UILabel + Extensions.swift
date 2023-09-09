//
//  UILabel + Extensions.swift
//  LocaPlace
//
//  Created by KODDER on 09.09.2023.
//

import UIKit

extension UILabel {
    
    convenience init(text: String = "") {
        self.init()
        
        self.text = text
        self.font = .systemFont(ofSize: 17)
        self.textColor = .label
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
