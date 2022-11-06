//
//  Alert+Extension.swift
//  Code-Test
//
//  Created by Cheuk Long on 6/11/2022.
//

import Foundation
import UIKit

extension UIAlertAction {
    func addImage(image: UIImage?) {
        self.setValue(image, forKey: "image")
    }
    
    func setTitleAlignment(alignment: CATextLayerAlignmentMode) {
        self.setValue(alignment, forKey: "titleTextAlignment")
    }
    
    func setTitleColor(color: UIColor) {
        self.setValue(color, forKey: "titleTextColor")
    }
}

