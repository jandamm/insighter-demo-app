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
    
    @IBInspectable var remoteConfigKey: String!
    @IBInspectable var fontStyle: String!
    
    
    // MARK: - Startup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        valuesInView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        styleView()
    }
    
    
    // MARK: - Interface Builder
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        styleView()
    }
    
    // MARK: - Private Methods
    
    private func styleView() {
        applyStyle()
    }
    
    private func valuesInView() {
        setText()
    }

}
