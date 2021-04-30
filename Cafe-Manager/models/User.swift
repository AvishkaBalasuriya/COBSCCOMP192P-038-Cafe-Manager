//
//  User.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-11.
//

import UIKit

class User: NSObject {
    var uuid:String
    var emailAddress:String
    var mobileNumber:String
    var password:String
    var type:Int
    
    init(uuid:String="",emailAddress:String="",mobileNumber:String="",password:String="",type:Int=0) {
        self.uuid=uuid
        self.emailAddress=emailAddress
        self.mobileNumber=mobileNumber
        self.password=password
        self.type=type
    }
}
