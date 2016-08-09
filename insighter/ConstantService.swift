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

    private var _ratingQuestion: String?
    private var _securityQuestions: [String]?
    private var _stringConstant = [String: String]()
    
    
    // MARK: - External Data
    
    var ratingQuestion: String {
        return _ratingQuestion == nil ? DBValueKeys.Constant.ratingQuestion.error : _ratingQuestion!
    }
    
    var securityQuestions: [String] {
        return _securityQuestions == nil ? [DBValueKeys.Constant.securityQuestions.error] : _securityQuestions!
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
                self.noConnectionToFirebase()
                self.constantsFromNSUD(completion)
                return
            }
            
            let firebaseVersion = String(data)
            
            NSLog("Constants: Local Version: \(self._versionDate); Firebase Version: \(firebaseVersion)")

            if firebaseVersion == self._versionDate {
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
        
        let success = NSUD.synchronize()
        
        NSLog("Saved Constants from Firebase to NSUD successful: \(success)")
    }
    
    private func constantsFromNSUD(completion: CompletionHandlerBool?) {
        var pick = 3
        
        if let stringConstant = NSUD.objectForKey(DBValueKeys.Constant.iOSStrings.value) as? [String: String] {
            _stringConstant = stringConstant
            pick -= 1
        }
        if let ratingQuestion = NSUD.stringForKey(DBValueKeys.Constant.ratingQuestion.value) {
            _ratingQuestion = ratingQuestion
            pick -= 1
        }
        if let securityQuestions = NSUD.objectForKey(DBValueKeys.Constant.securityQuestions.value) as? [String] {
            _securityQuestions = securityQuestions
            pick -= 1
        }
        
        let complete = pick == 0
        
        NSLog("Got Local Constants completely: \(complete)")
        
        completion?(complete)
    }
    
    
    // MARK: - Firebase
    
    private func constantsFromFirebase(completion: CompletionHandlerBool?) {
        NSLog("Getting Constants from Firebase")
        FIR_REF.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
                self.noConnectionToFirebase()
                completion?(false)
                return
            }
            
            var pick = 4
            
            if let version = data[DBValueKeys.Constant._versionDate.value] {
                self._versionDate = String(version)
                pick -= 1
            }
            
            if let stringConstant = data[DBValueKeys.Constant.iOSStrings.value] as? [String: String] {
                self._stringConstant = stringConstant
                pick -= 1
            }
            if let ratingQuestion = data[DBValueKeys.Constant.ratingQuestion.value] as? String {
                self._ratingQuestion = ratingQuestion
                pick -= 1
            }
            if let securityQuestions = data[DBValueKeys.Constant.securityQuestions.value] as? [String: AnyObject] {
                self._securityQuestions = Array(securityQuestions.keys)
                pick -= 1
            }
            
            let complete = pick == 0
            
            NSLog("Got Constants from Firebase completely: \(complete)")
            
            self.constantsToNSUD()
            completion?(complete)
        })
    }
    
    
    // MARK: - Private Methods
    
    private func noConnectionToFirebase() {
        NSLog("Constants: No connection to Firebase")
    }
    
}