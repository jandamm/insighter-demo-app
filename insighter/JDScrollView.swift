//
//  JDScrollView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class JDInputScrollView: UIScrollView {

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

		let contentInset: UIEdgeInsets = UIEdgeInsetsZero
		self.contentInset = contentInset
	}

	// MARK: - Private Methods

	private func setupScrollView() {
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false

		viewController.automaticallyAdjustsScrollViewInsets = false

		keyboardDismissMode = .Interactive
	}

	private func setupNotificationListenersForKeyboardEvents() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
	}
}

class JDPagingScrollView: UIScrollView {

	// MARK: - Outlets

	@IBOutlet weak var viewController: UIViewController!

	// MARK: - Startup

	override func awakeFromNib() {
		super.awakeFromNib()

		setupScrollView()
	}

	override func layoutSubviews() {
		setView()
	}

	// MARK: - Private Methods

	private func setView() {
		let pages = subviews.count

		for (i, view) in subviews.enumerate() {
			view.frame.origin.x = view.frame.width * CGFloat(i)
		}

		contentSize = CGSizeMake(frame.width * CGFloat(pages), frame.height)
	}

	private func setupScrollView() {
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false

		viewController.automaticallyAdjustsScrollViewInsets = false

		pagingEnabled = true
	}
}
