//
//  JDScrollView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class JDScrollView: UIScrollView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var viewController: UIViewController!

    
    // MARK: - Startup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupNotificationListenersForKeyboardEvents()
        setupScrollView()
    }
    
    
    // MARK: - Keyboard Actions
    
    func keyboardWillShow(notification: NSNotification) {
        
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = viewController.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset: UIEdgeInsets = self.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.contentInset = contentInset
    }
    
    
    // MARK: - Private Methods
    
    private func setupScrollView() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        keyboardDismissMode = .Interactive
    }
    
    private func setupNotificationListenersForKeyboardEvents() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name:UIKeyboardWillHideNotification, object: nil)
    }

}
