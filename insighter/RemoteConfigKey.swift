//
//  RemoteConfigKeys.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation


// The cases of this Enumeration should be RemoteConfigDefaults as well
// _ERROR_ is used to tell if there is an error


enum RemoteConfigKey: String, StringReturningEnum {
    case _ERROR_
    
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
    case Onb_Login_Anmeldung_Btn
}