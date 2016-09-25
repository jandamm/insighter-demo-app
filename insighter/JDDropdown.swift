//
//  JDDropdown.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class JDDropdown: UILabel, TextStylable, TextRemoteConfigable, Touchable {

	// MARK: - Design

	@IBInspectable var fontStyle: String! {
		didSet {
			applyTextStyle()
		}
	}

	@IBInspectable var remoteConfigKey: String! {
		didSet {
			setText()
		}
	}

	weak var imgView: UIImageView?

	var replaceStrings: [String: String]?

	// MARK: - Private Data

	private var dropdownShown = false {
		didSet {
			rotateArrow()
            
			if dropdownShown {
				presentDropdown()
			} else {
				popDropdown()
			}
		}
	}

	fileprivate var _dropdownList: [String]?
	fileprivate var _selection: String? {
		didSet {
			text = _selection
		}
	}

	// MARK: - External Data

	var selection: String? {
		return _selection
	}

	// MARK: - Startup

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		styleView()
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		applyTextStyle()
	}

	// MARK: - User Interaction

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let _ = touches.first else {
			return
		}

		dropdownShown = !dropdownShown
	}

	// MARK: - Appearance

	fileprivate func styleView() {
		if fontStyle == nil {
			applyTextStyle()
		}

		isUserInteractionEnabled = true
	}

	// MARK: - Internal Methods

	func setDataSource(_ source: [String]) {
		_dropdownList = source
		removeImageView()

		if source.count == 1 {
			_selection = source.first
		} else {
			addImageView()
		}
	}

	// MARK: - Private Methods
    
    private func presentDropdown() {
        // TODO
        
        print("dropdown")
    }
    
    private func popDropdown() {
        // TODO
        
        print("noDropdown")
    }

	private func rotateArrow() {
		guard let imgView = imgView else {
			return
		}

		let scaleY: CGFloat = dropdownShown ? -1 : 1

		UIView.animate(withDuration: 0.2) {
			imgView.transform = CGAffineTransform(scaleX: 1, y: scaleY)
		}
	}

	private func addImageView() {
		let imgView = UIImageView()

		self.imgView = imgView

		imgView.image = #imageLiteral(resourceName: "dropdown-arrow")
		addSubview(imgView)

		imgView.translatesAutoresizingMaskIntoConstraints = false

		let views = ["v": imgView]
		let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:[v(13)]-8-|", options: .directionLeadingToTrailing, metrics: nil, views: views)
		let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-9-[v(8)]", options: .directionLeadingToTrailing, metrics: nil, views: views)

		addConstraints(horizontal)
		addConstraints(vertical)
	}

	private func removeImageView() {
		imgView?.removeFromSuperview()
		imgView = nil
	}
}
