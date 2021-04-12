//
//  authService.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-11.
//

import UIKit
import FirebaseAuth

class authService: NSObject {
    
    func login(user:User,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.password != ""){
            Auth.auth().signIn(withEmail: user.emailAddress, password: user.password) { (response, error) in
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .invalidCredential:
                                result(401)
                            case .emailAlreadyInUse:
                                result(409)
                            default:
                                result(0)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    result(200)
                }
            }
        }else{
            result(400)
        }
    }
    
    func register(user:User,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.mobileNumber != "" && user.password != ""){
            Auth.auth().createUser(withEmail: user.emailAddress, password: user.mobileNumber) { (response, error) in
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .emailAlreadyInUse:
                                result(409)
                            default:
                                result(0)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    result(201)
                }
            }
        }else{
            result(400)
        }
    }
    
}
