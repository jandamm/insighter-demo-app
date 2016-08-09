//
//  Style.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class Colors {
    
    class func textColor() -> UIColor {
        return rgba(33, 33, 33, 1)
    }
    
    class func highlightColor() -> UIColor {
        return rgba(255, 166, 67, 1)
    }
    
    class func primaryColor() -> UIColor {
        return rgba(0, 156, 223, 1)
    }
    
    class func errorColor() -> UIColor {
        return rgba(244, 81, 83, 1)
    }
    
    static private func rgba(r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

enum TextStyle: String {
    case Heading, HeadingPrimary, HeadingHighlight
    case TextBig, TextBigPrimary, TextBigHighlight
    case Text, TextPrimary, TextHighlight, TextError
    
    func font() -> UIFont {
        let selfString = self.rawValue
        var size: CGFloat = 20
        var name = "AvenirNext-Regular"
        
        if selfString.containsString("Heading") {
            size = 25
        } else if selfString.containsString("TextBig") {
            size = 22
        }
        
        if selfString.containsString("Primary") || selfString.containsString("Highlight") {
            name = "AvenirNext-Medium"
        }
        
        return UIFont(name: name, size: size)!
    }
    
    func color() -> UIColor {
        let color: UIColor
        
        if String(self).containsString("Primary") {
            color = Colors.primaryColor()
        } else if String(self).containsString("Highlight") {
            color = Colors.highlightColor()
        } else if String(self).containsString("Error") {
            color = Colors.errorColor()
        } else {
            color = Colors.textColor()
        }
        
        return color
    }
}