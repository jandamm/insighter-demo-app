//
//  JDDropdown.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

//@IBDesignable
class JDDropdown: UILabel, TextStylable {
    
    // MARK: - Design
    
    @IBInspectable var fontStyle: String!
    
    
    // MARK: - Private Data
    
    private var _dropdownList: [String]?
    
    
    // MARK: - Startup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    private func applyDefaults() {
        
    }
    
    
    // MARK: - Global Methods
    
    func dataSource(source: [String]) {
        _dropdownList = source
        
        setLabel()
    }
    
    
    // MARK: - Private Methods
    
    private func setLabel() {
        guard let data = _dropdownList else {
            return
        }
        
        text = data.first
    }
    
    private func styleView() {
        applyStyle()
        applyDefaults()
    }
}