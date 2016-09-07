//
//  JDTextView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class JDTextView: UITextView, UITextViewDelegate, TextStylable {

    // MARK: - Design

    let fontStyle: String! = TextStyle.TextView.rawValue

    // MARK: - Startup

    override func layoutSubviews() {
        super.layoutSubviews()

        delegate = self

        styleView()
    }

    // MARK: - Interface Builder

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        applyTextStyle()
    }

    // MARK: - Dismiss Keyboard

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    // MARK: - Appearance

    private func styleView() {

        applyTextStyle()

        textContainerInset.left = 8
        textContainerInset.right = 8
        textContainerInset.top = 8
        textContainerInset.bottom = 8

        returnKeyType = .Done

        addBorder()
    }

    private func addBorder() {
        let border = CALayer()
        let lineWidth: CGFloat = 1

        border.borderColor = Colors.primaryColor().CGColor
        border.frame = CGRect(x: 0, y: 0, width: bounds.width - 1, height: bounds.height - 1)
        border.borderWidth = lineWidth

        layer.addSublayer(border)
    }
}
