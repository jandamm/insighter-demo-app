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
    
    func applyStyle()
}

extension TextStylable where Self: UILabel {
    
    func applyStyle() {
        let style = getStyle()
        
        font = style.font()
        textColor = style.color()
    }
    
}

extension TextStylable where Self: UIButton {
    
    func applyStyle() {
        let style = getStyle()
        
        titleLabel?.font = style.font()
        setTitleColor(style.color(), forState: UIControlState.Normal)
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
