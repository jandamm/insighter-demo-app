//
//  JDLabel.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

@IBDesignable
class JDLabel: UILabel, TextStylable, TextRemoteConfigable {
    
    // MARK: - Design

    @IBInspectable var remoteConfigKey: String!
    @IBInspectable var fontStyle: String!
    @IBInspectable var overrideDefaultSettings: Bool!
    
    
    // MARK: - Startup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyle()
        setText()
        applyDefaults()
    }
    
    
    // MARK: - Interface Builder
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        applyStyle()
    }
    
    
    // MARK: - Private Methods
    
    private func applyDefaults() {
        if let b = overrideDefaultSettings where b {
            return
        }
        
        numberOfLines = 3
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
    }
}
