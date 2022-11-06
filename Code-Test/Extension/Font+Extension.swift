//
//  Font+Extension.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import UIKit

extension UIFont {
    static func appFont(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize * RelativeConstraint.ratio)
    }
    
    static func appBoldFont(ofSize: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: ofSize * RelativeConstraint.ratio)
    }
}
