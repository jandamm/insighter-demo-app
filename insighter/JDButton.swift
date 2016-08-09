//
//  JDButton.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

@IBDesignable
class JDButton: UIButton, TextStylable, TextRemoteConfigable {

    // MARK: - Design
    
    @IBInspectable var remoteConfigKey: String!
    @IBInspectable var fontStyle: String!
    
    
    // MARK: - Startup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyle()
        setText()
    }
    
    
    // MARK: - Interface Builder
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        applyStyle()
    }

}
