//
//  RemoteConfigable.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol TextRemoteConfigable {
	var remoteConfigKey: String! { get set }
	var replaceStrings: [String: String]? { get }

	func setText()
}

extension TextRemoteConfigable where Self: UIButton {

	func setText() {
		let title = getValue()

		setTitle(title, for: UIControlState())
	}
}

extension TextRemoteConfigable where Self: UILabel {

	func setText() {
		text = getValue()
	}
}

extension TextRemoteConfigable where Self: UITextField {

	func setText() {
		let text = getValue()
		attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: Colors.lightContrast])
	}
}

extension TextRemoteConfigable {

	fileprivate func getKey() -> RemoteStringKey {
		guard let rawKey = remoteConfigKey else {
			return RemoteStringKey._ERROR_NO_KEY
		}

		guard let key = RemoteStringKey(rawValue: rawKey) else {
			return RemoteStringKey._ERROR_WRONG_KEY
		}

		return key
	}

	fileprivate func getValue() -> String {
		let key = getKey()

		var value = RemoteConfig.shared.getString(forKey: key)

		if let replace = replaceStrings {
			for (ofString, withString) in replace {
				value = value.replacingOccurrences(of: ofString, with: withString)
			}
		}

		return value
	}
}
