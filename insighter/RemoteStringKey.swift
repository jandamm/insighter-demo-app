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
	case Per_Max_Points
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
	case Onb_Login_Anmeldung_Btn

	// Question Rating Screen
	case Que_Number_Of_Number
	case Que_Rating_Slider_Left_Lbl
	case Que_Rating_Slider_Right_Lbl
	case Que_Rating_Comment_Btn
	case Que_Rating_Save_Btn

	// Question Comment Screen
	case Que_Comment_Save_Btn
	case Que_Comment_Discard_Btn

	// Evaluation Date
	case Eva_Date_Lbl

	// Evaluation User Screen
	case Eva_User_Title_Lbl
	case Eva_User_Rating_Title_Lbl
	case Eva_User_Feedback_Title_Lbl
	case Eva_User_Punkte_Title_Lbl
	case Eva_User_Punkte_Top_Lbl
	case Eva_User_Punkte_Middle_Lbl
	case Eva_User_Punkte_Bottom_Lbl
	case Eva_User_Punkte_Sum_Lbl

	// Evaluation Company Screen
	case Eva_Comp_Title_Lbl
	case Eva_Comp_User_Title_Lbl
	case Eva_Comp_Comp_Title_Lbl
	case Eva_Comp_Diff_Relation_Lbl
	case Eva_Comp_Verlauf_Lbl
}
