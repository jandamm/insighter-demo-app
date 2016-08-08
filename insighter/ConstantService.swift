//
//  ConstantService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

enum StringConstant: StringReturningEnum {
    case companyMailLabel
}

class ConstantService {
    static let sharedInstance = ConstantService()
    
    private let FIR_REF = FIRDatabase.database().reference().child(DBPathKeys.constant.value)
    private let NSUD = NSUserDefaults.standardUserDefaults()
    
    
    // MARK: - Private Data
    
    private var _versionDate = ""

    private var _ratingQuestion: String!
    private var _securityQuestions: [String]!
    private var _stringConstant = [String: String]()
    
    
    // MARK: - External Data
    
    var ratingQuestion: String {
        return _ratingQuestion == nil ? DBValueKeys.Constant.ratingQuestion.error : _ratingQuestion
    }
    
    var securityQuestions: [String] {
        return _securityQuestions == nil ? [DBValueKeys.Constant.securityQuestions.error] : _securityQuestions
    }
    
    
    // MARK: - Global Methods
    
    func getConstant(forKey key: StringConstant) -> String {
        guard let value = _stringConstant[key.value] else {
            return key.error
        }
        
        return value
    }
    
    func initiateConstants(completion: CompletionHandlerBool?) {
        
        versionFromNSUD()
        
        FIR_REF.child(DBValueKeys.Constant._versionDate.value).observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value else {
                NSLog("No connection")
                self.constantsFromNSUD(completion)
                return
            }

            if String(data) == self._versionDate {
                self.constantsFromNSUD(completion)
            } else {
                self.constantsFromFirebase(completion)
            }
        })
    }
    
    
    // MARK: - NSUserDefaults
    
    private func versionFromNSUD() {
        if let versionDate = NSUD.stringForKey(DBValueKeys.Constant._versionDate.value) {
            _versionDate = versionDate
        }
    }
    
    private func constantsToNSUD() {
        NSUD.setValue(_versionDate, forKey: DBValueKeys.Constant._versionDate.value)
        NSUD.setValue(_stringConstant, forKey: DBValueKeys.Constant.iOSStrings.value)
        NSUD.setValue(_ratingQuestion, forKey: DBValueKeys.Constant.ratingQuestion.value)
        NSUD.setValue(_securityQuestions, forKey: DBValueKeys.Constant.securityQuestions.value)
        
        NSUD.synchronize()
    }
    
    private func constantsFromNSUD(completion: CompletionHandlerBool?) {
        let pick = 3
        var picked = 0
        
        if let stringConstant = NSUD.objectForKey(DBValueKeys.Constant.iOSStrings.value) as? [String: String] {
            _stringConstant = stringConstant
            picked += 1
        }
        if let ratingQuestion = NSUD.stringForKey(DBValueKeys.Constant.ratingQuestion.value) {
            _ratingQuestion = ratingQuestion
            picked += 1
        }
        if let securityQuestions = NSUD.objectForKey(DBValueKeys.Constant.securityQuestions.value) as? [String] {
            _securityQuestions = securityQuestions
            picked += 1
        }
        
        completion?(pick == picked)
    }
    
    
    // MARK: - Firebase
    
    private func constantsFromFirebase(completion: CompletionHandlerBool?) {
        FIR_REF.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
                NSLog("No constants")
                completion?(false)
                return
            }
            
            if let version = data[DBValueKeys.Constant._versionDate.value] as? String {
                self._versionDate = version
            }
            
            if let stringConstant = data[DBValueKeys.Constant.iOSStrings.value] as? [String: String] {
                self._stringConstant = stringConstant
            }
            if let ratingQuestion = data[DBValueKeys.Constant.ratingQuestion.value] as? String {
                self._ratingQuestion = ratingQuestion
            }
            if let securityQuestions = data[DBValueKeys.Constant.securityQuestions.value] as? [String: AnyObject] {
                self._securityQuestions = Array(securityQuestions.keys)
            }
            
            self.constantsToNSUD()
            completion?(true)
        })
    }
    
}
