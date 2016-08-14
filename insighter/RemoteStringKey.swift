//
//  RemoteStringKey.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation


// The cases of this Enumeration should be RemoteConfigDefaults as well
// _ERROR_ are used to tell if there is an invalid/no key


enum RemoteStringKey: String, StringReturningEnum {
    case _EMPTY_
    case _ERROR_WRONG_KEY
    case _ERROR_NO_KEY
    
    // Login Errors
    case ERROR_INVALID_EMAIL
    case ERROR_EMAIL_ALREADY_IN_USE
    case ERROR_WEAK_PASSWORD
    case ERROR_WRONG_PASSWORD
    case ERROR_QUESTION_NOT_CHOSEN
    case ERROR_QUESTION_ANSWER_TOO_SHORT
    case ERROR_COMPANY_UNKNOWN
    case ERROR_UNKNOWN_TITLE
    case ERROR_UNKNOWN_EXPLANATION
    
    // Basics
    case Our_Company_Name
    case Notif_Reminder_Title
    case Notif_Reminder_Body
    case Notif_Reminder_Action
    
    // Onboarding Willkommen Screen
    case Onb_Will_Willkommen_Lbl
    case Onb_Will_Wir_Verbessern_Lbl
    case Onb_Will_Anonym_Top_Lbl
    case Onb_Will_Anonym_Middle_Lbl
    case Onb_Will_Anonym_Bottom_Lbl
    case Onb_Will_Next_Btn
    
    // Onboarding Login Screen
    case Onb_Notif_Erklaerung_Lbl
    case Onb_Notif_Systemmeldung_Lbl
    case Onb_Notif_Btn
    
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
    case Onb_Login_Anmeldung_Btn_Log
    case Onb_Login_Anmeldung_Btn_Reg
    
    // Evaluation User Screen
    case Eva_User_Title_Lbl
    case Eva_User_Rating_Title_Lbl
    case Eva_User_Feedback_Title_Lbl
    case Eva_User_Feedback_Erklaerung_Lbl
    case Eva_User_Punkte_Title_Lbl
}