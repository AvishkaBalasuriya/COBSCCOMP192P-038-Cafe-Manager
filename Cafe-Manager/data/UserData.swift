//
//  UserData.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-27.
//

import Foundation

struct UserData {
    static var emailAddress:String = ""
    static var mobileNumber:String = ""
}

func setUserData(user:User){
    UserData.emailAddress=user.emailAddress
    UserData.mobileNumber=user.mobileNumber
}
