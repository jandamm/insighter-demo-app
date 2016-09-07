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

	func setText()
}

extension TextRemoteConfigable where Self: UIButton {

	func setText() {
		let title = getValue()
		setTitle(title, forState: .Normal)
	}
}

extension TextRemoteConfigable where Self: UILabel {

	func setText() {
		text = getValue()
	}
}

extension TextRemoteConfigable where Self: UITextField {

	func setText() {
		placeholder = getValue()
	}
}

extension TextRemoteConfigable {

	private func getKey() -> RemoteStringKey {
		guard let rawKey = remoteConfigKey else {
			return RemoteStringKey._ERROR_NO_KEY
		}

		guard let key = RemoteStringKey(rawValue: rawKey) else {
			return RemoteStringKey._ERROR_WRONG_KEY
		}

		return key
	}

	private func getValue() -> String {
		let key = getKey()

		return RemoteConfig.sharedInstance.getString(forKey: key)
	}
}
