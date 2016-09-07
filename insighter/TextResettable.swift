//
//  TextResettable.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol TextResettable: TextRemoteConfigable {
    var remoteConfigKeyDefault: String! { get }
}

extension TextResettable {

    mutating func resetRemoteConfigText() {
        if remoteConfigKey != remoteConfigKeyDefault {
            remoteConfigKey = remoteConfigKeyDefault
        }
    }
}
