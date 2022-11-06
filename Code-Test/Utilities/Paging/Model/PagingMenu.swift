//
//  PagingMenu.swift
//  Code_Test
//
//  Created by Cheuk Long on 3/11/2022.
//

import Foundation
import UIKit

class PagingMenu {
    var title: String
    var vc: UIViewController
    var customInfo: [String: Any]
    
    init(title: String = "", vc: UIViewController = .init(), customInfo: [String: Any] = [:]) {
        self.title = title
        self.vc = vc
        self.customInfo = customInfo
    }
}
