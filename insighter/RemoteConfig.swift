//
//  RemoteConfig.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

class RemoteConfig {
	static let sharedInstance = RemoteConfig()

	fileprivate let remoteConfig = FIRRemoteConfig.remoteConfig()

	// MARK: - Initialization

	init() {
		#if DEBUG
			let settings = FIRRemoteConfigSettings(developerModeEnabled: true)
			remoteConfig.configSettings = settings!
		#endif

		remoteConfig.setDefaultsFromPlistFileName("RemoteConfigDefaults")
	}

	// MARK: - External Methods

	func getRemoteConfigValues(_ completion: CompletionHandlerBool?) {
		let expDuration = remoteConfig.configSettings.isDeveloperModeEnabled ? 0 : 3600

		remoteConfig.fetch(withExpirationDuration: TimeInterval(expDuration)) { (status, error) in
			if (status == FIRRemoteConfigFetchStatus.success) {
				self.remoteConfig.activateFetched()
				NSLog("[JD] RemoteConfig successfully fetched and activated")
				completion?(true)
			} else {
				let errorString = error == nil ? "Error unspecified" : error!.localizedDescription

				NSLog("[JD] Config not fetched: \(errorString)")
				completion?(false)
			}
		}
	}

	// MARK: - Get Values

	func getString(forKey key: RemoteStringKey) -> String {
		guard let value = remoteConfig[key.rawValue].stringValue else {
			return key.error
		}

		return value
	}

	func getDouble(forKey key: RemoteDoubleKey) -> Double {
		return getNSNumber(forValue: key.rawValue).doubleValue
	}

	func getInt(forKey key: RemoteIntKey) -> Int {
		return getNSNumber(forValue: key.rawValue).intValue
	}

	fileprivate func getNSNumber(forValue key: String) -> NSNumber {
		guard let value = remoteConfig[key].numberValue else {
			return 0
		}

		return value
	}
}
