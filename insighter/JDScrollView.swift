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

	func keyboardWillShow(_ notification: Notification) {

		var userInfo = (notification as NSNotification).userInfo!
		var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = viewController.view.convert(keyboardFrame, from: nil)

		var contentInset: UIEdgeInsets = self.contentInset
		contentInset.bottom = keyboardFrame.size.height
		self.contentInset = contentInset
	}

	func keyboardWillHide(_ notification: Notification) {

		let contentInset: UIEdgeInsets = UIEdgeInsets.zero
		self.contentInset = contentInset
	}

	// MARK: - Private Methods

	fileprivate func setupScrollView() {
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false

		viewController.automaticallyAdjustsScrollViewInsets = false

		keyboardDismissMode = .interactive
	}

	fileprivate func setupNotificationListenersForKeyboardEvents() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

	fileprivate func setView() {
		let pages = subviews.count

		for (i, view) in subviews.enumerated() {
			view.frame.origin.x = view.frame.width * CGFloat(i)
		}

		contentSize = CGSize(width: frame.width * CGFloat(pages), height: frame.height)
	}

	fileprivate func setupScrollView() {
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false

		viewController.automaticallyAdjustsScrollViewInsets = false

		isPagingEnabled = true
	}
}
