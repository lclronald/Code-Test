//
//  Color+Extension.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import UIKit

extension UIColor {
    static let color_aeaeae = initColor(r: 174, g: 174, b: 174)
    
    
    
    
    
    
    
    
    
    static func initColor(r: Double, g: Double, b: Double) -> UIColor {
        return .init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
