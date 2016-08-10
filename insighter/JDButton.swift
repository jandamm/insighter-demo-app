//
//  JDButton.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

//@IBDesignable
class JDButton: UIButton, TextStylable, TextRemoteConfigable {

    // MARK: - Design
    
    @IBInspectable var remoteConfigKey: String! {
        didSet {
            setText()
        }
    }
    @IBInspectable var fontStyle: String! {
        didSet {
            applyTextStyle()
        }
    }
    
    
    // MARK: - Startup
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        styleView()
    }
    
    
    // MARK: - Interface Builder
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        applyTextStyle()
    }
    
    
    // MARK: - Appearance
    
    private func styleView() {
        if fontStyle == nil {
            applyTextStyle()
        }
    }

}
