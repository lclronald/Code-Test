//
//  RelativeConstraint.swift
//  Code_Test
//
//  Created by Cheuk Long on 3/11/2022.
//

import UIKit

class RelativeConstraint: NSLayoutConstraint {
    
    static let relativeToWidth: CGFloat = 375
    static let sharedInstance = RelativeConstraint()
    static var ratio: CGFloat = min(UIScreen.main.bounds.width / relativeToWidth, 1.25)
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        if RelativeConstraint.ratio != 1 {
            constant = RelativeConstraint.round(constant)
        }
        
        return super.awakeAfter(using: aDecoder)
    }
    
    static func round(_ value: CGFloat) -> CGFloat {
        return (value * RelativeConstraint.ratio).rounded()
    }
    
}
