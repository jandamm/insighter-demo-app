//
//  LoadingView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

//@IBDesignable
class LoadingView: UIView {
    
    // MARK: - Variables
    
    private var animate = false
    private var _boundsMax: CGRect!
    private var _boundsMin: CGRect!
    
    
    // MARK: - Startup
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutView()
    }

    
    // MARK: - Interface Builder
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        layoutView()
    }
    
    
    // MARK: - Global Methods
    
    func animationStart() {
        let width = bounds.width
        let widthMin = width * 0.25
        let inset = (width - widthMin) / 2
        
        animate = true
        
        _boundsMax = CGRectMake(0, 0, width, width)
        _boundsMin = CGRectMake(inset, inset, widthMin, widthMin)
        
        animation()
    }
    
    func animationStop() {
        animate = false
    }
    
    
    // MARK: - Animation
    
    private func animation() {
        guard animate else {
            return
        }
        
        UIView.animateWithDuration(1, animations: {
            self.bounds = self.bounds == self._boundsMax ? self._boundsMin : self._boundsMax
            }) { _ in
                self.animation()
        }
    }
    
    
    // MARK: - Layout

    private func layoutView() {
        layer.cornerRadius = bounds.width / 2
    }
}
