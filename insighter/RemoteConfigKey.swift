//
//  RemoteConfigKeys.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation


// The cases of this Enumeration should be RemoteConfigDefaults as well
// _ERROR_ are used to tell if there is an invalid/no key


enum RemoteConfigKey: String, StringReturningEnum {
    case _EMPTY_
    case _ERROR_WRONG_KEY
    case _ERROR_NO_KEY
    
    // Login Errors
    case ERROR_INVALID_EMAIL
    case ERROR_EMAIL_ALREADY_IN_USE
    case ERROR_WEAK_PASSWORD
    case ERROR_WRONG_PASSWORD
    case ERROR_QUESTION_NOT_CHOSEN
    case ERROR_QUESTION_NOT_ANSWERED
    case ERROR_COMPANY_UNKNOWN
    
    // Basics
    case Our_Company_Name
    
    // Onboarding Willkommen Screen
    case Onb_Will_Willkommen_Lbl
    case Onb_Will_Wir_Verbessern_Lbl
    case Onb_Will_Anonym_Top_Lbl
    case Onb_Will_Anonym_Middle_Lbl
    case Onb_Will_Anonym_Bottom_Lbl
    case Onb_Will_Next_Btn
    
    // Onboarding Login Screen
    case Onb_Login_Anmeldung_Lbl
    case Onb_Login_Email_Lbl
    case Onb_Login_Email_TxtField
    case Onb_Login_PW_Lbl
    case Onb_Login_PW_TxtField
    case Onb_Login_PW_SubLbl
    case Onb_Login_Security_Dropdown
    case Onb_Login_Security_TxtField
    case Onb_Login_Security_SubLbl
    case Onb_Login_Anmeldung_Btn_Login
    case Onb_Login_Anmeldung_Btn_Register
}