//
//  RemoteIntKey.swift
//  insighter
//
//  Created by Jan Dammshäuser on 12.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

enum RemoteIntKey: String, StringReturningEnum {
	case _ERROR_

	// Notification Times
	case Notif_Trigger_Weekday
	case Notif_Trigger_Hour

	// Questions
	case Questions_Per_Week
}
