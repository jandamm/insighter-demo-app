//
//  TextStylable.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol TextStylable {
    var fontStyle: String! { get }
    
    func applyTextStyle()
}

extension TextStylable where Self: UIButton {
    
    func applyTextStyle() {
        let style = getStyle()
        
        titleLabel?.font = style.font()
        setTitleColor(style.color(), forState: UIControlState.Normal)
        setTitleColor(style.color().colorWithAlphaComponent(0.45), forState: UIControlState.Disabled)
    }
    
}

extension TextStylable where Self: UILabel {
    
    func applyTextStyle() {
        let style = getStyle()
        
        font = style.font()
        textColor = style.color()
    }
    
}

extension TextStylable where Self: UITextField {
    
    func applyTextStyle() {
        let style = getStyle()
        
        font = style.font()
        textColor = style.color()
    }
    
}

extension TextStylable where Self: UITextView {
    
    func applyTextStyle() {
        let style = getStyle()
        
        font = style.font()
        textColor = style.color()
    }
    
}

extension TextStylable {
    
    private func getStyle() -> TextStyle {
        guard let font = fontStyle, let style = TextStyle(rawValue: font) else {
            return TextStyle.Text
        }
        
        return style
    }
    
}
