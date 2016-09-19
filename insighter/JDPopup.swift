//
//  JDPopup.swift
//  insighter
//
//  Created by Jan Dammshäuser on 11.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JGProgressHUD

class JDPopup: JGProgressHUD {

	enum ImageStyle {
		case error
		case success
	}

	convenience init(titleKey: RemoteStringKey, subTitleKey: RemoteStringKey, imageStyle: ImageStyle) {
		let title = RemoteConfig.shared.getString(forKey: titleKey)
		let subTitle = RemoteConfig.shared.getString(forKey: subTitleKey)

		self.init(title: title, subTitle: subTitle, imageStyle: imageStyle)
	}

	init(title: String, subTitle: String, imageStyle: ImageStyle) {
		super.init(style: .extraLight)

		let imageName: String

		switch imageStyle {
		case .error:
			imageName = "popup-error-img"
		case .success:
			imageName = "popup-success-img"
		}

		textLabel.text = title
		detailTextLabel.text = subTitle
		cornerRadius = 3
		dismiss(afterDelay: 2, animated: true)
		indicatorView = JGProgressHUDImageIndicatorView(image: UIImage(named: imageName))
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
