//
//  PagingUnderlineFocusView.swift
//  Code_Test
//
//  Created by Cheuk Long on 3/11/2022.
//

import Foundation
import PagingKit

class PagingUnderlineFocusView: PagingMenuFocusView  {
    private static let default_underline_height: CGFloat = 2.5
    
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var cUnderlineHeight: RelativeConstraint!
    
    func setUnderlineHeight(height: CGFloat? = nil) {
        self.cUnderlineHeight.constant = height ?? PagingUnderlineFocusView.default_underline_height
    }
}
