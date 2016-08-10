//
//  JDTextField.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import NextResponderTextField

//@IBDesignable
class JDTextField: NextResponderTextField, TextStylable, TextRemoteConfigable {
    
    // MARK: - Outlets
    
    @IBOutlet weak var NextResponder: UIControl?
    
    
    // MARK: - Design
    
    @IBInspectable var remoteConfigKey: String!
    @IBInspectable var fontStyle: String!
    
    
    // MARK: - Startup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.nextResponderField = NextResponder
        
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
    
    
    // MARK: - Appearance
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x+12, bounds.origin.y+4, bounds.width-24, bounds.height-4)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    private func applyDefaults() {
        minimumFontSize = 14
        adjustsFontSizeToFitWidth = true
        borderStyle = .None
        enablesReturnKeyAutomatically = true
        
        addLine()
    }
    
    private func addLine() {
        let line = CALayer()
        let lineWidth: CGFloat = 1
        
        line.borderColor = Colors.primaryColor().CGColor
        line.frame = CGRect(x: 0, y: bounds.height-lineWidth, width: bounds.width, height: lineWidth)
        line.borderWidth = lineWidth
        
        
        layer.addSublayer(line)
    }
    
    
    // MARK: - Private Methods
    
    private func styleView() {
        applyStyle()
        applyDefaults()
    }
    
    private func valuesInView() {
        setText()
    }

}
