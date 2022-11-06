//
//  String+Extension.swift
//  Code_Test
//
//  Created by Cheuk Long on 3/11/2022.
//

import Foundation
import UIKit

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func getTextSize(font:UIFont, widthExtra:CGFloat = 0, heightExtra:CGFloat = 0) -> CGSize {
        let size = (self as NSString).size(withAttributes: [NSAttributedString.Key.font:font])
        return .init(width: size.width + widthExtra, height: size.height + heightExtra)
    }
}
