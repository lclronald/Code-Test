//
//  View+Extension.swift
//  Code_Test
//
//  Created by Cheuk Long on 3/11/2022.
//

import Foundation
import UIKit

extension UIView {
    static var className: String {
        return String(describing: self)
    }
    
    func roundCorner(radius: CGFloat = 0, maskedCorners: CACornerMask? = nil) {
        DispatchQueue.main.async(execute: {
            let cornerRadius = (radius == 0) ? self.frame.height / 2 : radius * RelativeConstraint.ratio
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius
            if let maskedCorners = maskedCorners {
                self.layer.maskedCorners = maskedCorners
            }
        })
    }
    
    
}
