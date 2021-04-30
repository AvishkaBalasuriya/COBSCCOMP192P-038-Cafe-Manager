//
//  authService.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-11.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FirebaseService: NSObject {
    
    let notificationService = NotificationService()
    
    func login(user:User,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.password != ""){
            Auth.auth().signIn(withEmail: user.emailAddress, password: user.password) { (response, error) in
                print(error)
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .wrongPassword:
                                result(401)
                            case .invalidCredential:
                                result(401)
                            case .emailAlreadyInUse:
                                result(409)
                            case .userNotFound:
                                result(401)
                            case .invalidEmail:
                                result(401)
                            default:
                                result(500)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    UserDefaults.standard.set(true, forKey: "isLogged")
                    UserDefaults.standard.set(user.emailAddress, forKey: "emailAddress")
                    UserDefaults.standard.set(response?.user.uid, forKey: "uuid")
                    UserData.emailAddress=user.emailAddress
                    UserData.uuid=(response?.user.uid)!
                    
                    result(200)
                }
            }
        }else{
            result(400)
        }
    }
    
    func register(user:User,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.mobileNumber != "" && user.password != ""){
            Auth.auth().createUser(withEmail: user.emailAddress, password: user.password) { (response, error) in
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .emailAlreadyInUse:
                                result(409)
                            default:
                                result(500)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    firestoreDataService().addUserToFirestore(user: user){
                        completion in
                        if (completion != nil){
                            user.uuid=(response?.user.uid)!
                            
                            UserDefaults.standard.set(true, forKey: "isLogged")
                            UserDefaults.standard.set(user.emailAddress, forKey: "emailAddress")
                            UserDefaults.standard.set(user.mobileNumber, forKey: "mobileNumber")
                            UserDefaults.standard.set(response?.user.uid, forKey: "uuid")
                            
                            UserData.emailAddress=user.emailAddress
                            UserData.mobileNumber=user.mobileNumber
                            UserData.uuid=(response?.user.uid)!
                            result(201)
                        }else{
                            result(500)
                        }
                    }
                }
            }
        }else{
            result(400)
        }
    }
    
    func forgetPassword(emailAddress:String,result: @escaping (_ authResult: Int?)->Void){
        if (emailAddress != ""){
            Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .invalidEmail:
                                    result(401)
                            default:
                                result(500)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    UserDefaults.standard.set(false, forKey: "isLogged")
                    result(200)
                }
            }
        }else{
            result(400)
        }
    }
    
    
    func listenToOrderStatus(){
        let ref = Database.database().reference().child("orders")
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if !snapshot.exists() {
                    return
            }
            var masterData = snapshot.value as! [String: [String:Any]]
            for (userId,value) in masterData{
                for (orderId,value) in value{
                    let statusData = value as! [String:Any]
                    var orderStatusData:StatusData=StatusData()
                    orderStatusData.orderId=statusData["orderId"] as! String
                    orderStatusData.status=statusData["status"] as! Int
                    orderStatusData.isRecieved=statusData["isRecieved"] as! Bool
                    if orderStatusData.status == 0 || orderStatusData.status == 3{
                        if orderStatusData.isRecieved == false{
                            self.notificationService.pushNotification(orderId: orderStatusData.orderId, orderStatus: orderStatusData.status){
                                result in
                                if result == true{
                                    self.markStatusAsRecieved(orderStatusData: orderStatusData, userId:userId, key: orderId)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func updateOrderStatus(orderId:String,status:Int,userId:String){
        let ref = Database.database().reference().child("orders").child(userId).child(orderId)
        ref.updateChildValues(["status":status,"isRecieved":false])
    }
    
    func markStatusAsRecieved(orderStatusData:StatusData,userId:String,key:String){
        orderStatusData.isRecieved=true
        let ref = Database.database().reference().child("orders").child(userId).child(key).setValue(orderStatusData.asDictionary)
    }
    
}
