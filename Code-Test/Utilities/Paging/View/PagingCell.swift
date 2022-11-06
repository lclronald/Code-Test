//
//  PagingCell.swift
//  Code_Test
//
//  Created by Cheuk Long on 3/11/2022.
//

import Foundation
import PagingKit

class PagingCell: PagingMenuViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    private var textColor: UIColor = .black
    private var focusColor: UIColor = .black
    private var textFont: UIFont = .systemFont(ofSize: 12.0)
    private var focusFont: UIFont = .systemFont(ofSize: 12.0)
    private var normalBG: UIColor = .black
    private var focusBG: UIColor = .black
    
    override public var isSelected: Bool { didSet { self.updateUI() }}
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    private func updateUI() {
        self.titleLbl.textColor = self.isSelected ?  self.focusColor : self.textColor
        self.titleLbl.font = self.isSelected ? self.focusFont : self.textFont

        self.backgroundColor = self.isSelected ? self.focusBG : self.normalBG
    }
    
    func setContent(text: String) {
        self.titleLbl.text = text
        self.updateUI()
    }
    
    func updateStyle(textColor: UIColor? = nil,
                     focusColor: UIColor? = nil,
                     textFont: UIFont? = nil,
                     focusFont: UIFont? = nil,
                     normalBG: UIColor? = nil,
                     focusBG: UIColor? = nil) {
        
        if let c = textColor        { self.textColor = c }
        if let c = focusColor       { self.focusColor = c }
        if let f = textFont         { self.textFont = f }
        if let f = focusFont        { self.focusFont = f }
        if let c = normalBG         { self.normalBG = c }
        if let c = focusBG          { self.focusBG = c }
        
        self.updateUI()
    }
}
