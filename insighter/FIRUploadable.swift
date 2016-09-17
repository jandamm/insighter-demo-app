//
//  FIRUploadable.swift
//  insighter
//
//  Created by Jan Dammshäuser on 11.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

protocol FIRUploadable {
	var FIR_PATH: String { get }
	var uploadData: [String: AnyObject] { get }
}

extension FIRUploadable {

	func upload() {
		let data = uploadData
		guard data.count > 0 else {
			return NSLog("[JD] Nothing uploaded, data was empty")
		}

		FIRDatabase.database().reference().child(FIR_PATH).updateChildValues(data)

		NSLog("[JD] Uploaded \(self) to \(FIR_PATH)")
	}
}
