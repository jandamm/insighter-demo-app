//
//  RemoteConfigable.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol TextRemoteConfigable {
    var remoteConfigKey: String! { get }
    
    func setText()
}

extension TextRemoteConfigable where Self: UILabel {
    
    func setText(){
        text = getValue()
    }
    
}

extension TextRemoteConfigable where Self: UIButton {
    
    func setText(){
        let title = getValue()
        setTitle(title, forState: .Normal)
    }
    
}

extension TextRemoteConfigable {
    
    private func getKey() -> RemoteConfigKey {
        guard let rawKey = remoteConfigKey, let key = RemoteConfigKey(rawValue: rawKey) else {
            return RemoteConfigKey._ERROR_
        }
        
        return key
    }
    
    private func getValue() -> String {
        let key = getKey()
        
        return RemoteConfig.sharedInstance.getString(forKey: key)
    }
    
}
