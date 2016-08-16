//
//  InsighterKit.swift
//  insighter-app
//
//  Created by Jan Dammshäuser on 16.08.16.
//  Copyright (c) 2016 insighter. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class InsighterKit : NSObject {

    //// Drawing Methods

    public class func drawSliderView(sliderColor sliderColor: UIColor = UIColor(red: 1.000, green: 0.651, blue: 0.263, alpha: 1.000), width: CGFloat = 311, sliderFraction: CGFloat = 0.5) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Color Declarations
        let backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.000)

        //// Variable Declarations
        let scaling: CGFloat = width / 311.0
        let height: CGFloat = scaling * 75
        let topMargin: CGFloat = (85 - height) / 2.0
        let angle: CGFloat = -45 - sliderFraction * (135 - 45)

        //// SliderGroup
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 0, topMargin)
        CGContextScaleCTM(context, scaling, scaling)

        CGContextBeginTransparencyLayer(context, nil)

        //// Clip Clip
        let clipPath = UIBezierPath()
        clipPath.moveToPoint(CGPointMake(295.31, 73.64))
        clipPath.addLineToPoint(CGPointMake(311, 57.81))
        clipPath.addCurveToPoint(CGPointMake(155.93, 0), controlPoint1: CGPointMake(275.69, 22.72), controlPoint2: CGPointMake(219.38, 0))
        clipPath.addCurveToPoint(CGPointMake(0, 58.68), controlPoint1: CGPointMake(91.97, 0), controlPoint2: CGPointMake(35.25, 23.09))
        clipPath.addLineToPoint(CGPointMake(16.18, 75))
        clipPath.addCurveToPoint(CGPointMake(156.43, 23.34), controlPoint1: CGPointMake(47.15, 43.76), controlPoint2: CGPointMake(98.42, 23.34))
        clipPath.addCurveToPoint(CGPointMake(295.31, 73.64), controlPoint1: CGPointMake(213.59, 23.34), controlPoint2: CGPointMake(264.21, 43.17))
        clipPath.closePath()
        clipPath.usesEvenOddFillRule = true;

        clipPath.addClip()


        //// BackgroundRect Drawing
        let backgroundRectPath = UIBezierPath(rect: CGRectMake(0, 0, 311, 75))
        backgroundColor.setFill()
        backgroundRectPath.fill()


        //// AngledRect Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 155.03, 214.97)
        CGContextRotateCTM(context, -angle * CGFloat(M_PI) / 180)

        let angledRectPath = UIBezierPath(rect: CGRectMake(-229.11, 0, 458.21, 246.12))
        sliderColor.setFill()
        angledRectPath.fill()

        CGContextRestoreGState(context)


        CGContextEndTransparencyLayer(context)

        CGContextRestoreGState(context)
    }

    public class func drawCanvas1(sliderColor sliderColor: UIColor = UIColor(red: 1.000, green: 0.651, blue: 0.263, alpha: 1.000)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Symbol Drawing
        let symbolRect = CGRectMake(72, 83, 311, 75)
        CGContextSaveGState(context)
        UIRectClip(symbolRect)
        CGContextTranslateCTM(context, symbolRect.origin.x, symbolRect.origin.y)
        CGContextScaleCTM(context, symbolRect.size.width / 311, symbolRect.size.height / 85)

        InsighterKit.drawSliderView(sliderColor: sliderColor, width: 311, sliderFraction: 0.5)
        CGContextRestoreGState(context)
    }

}