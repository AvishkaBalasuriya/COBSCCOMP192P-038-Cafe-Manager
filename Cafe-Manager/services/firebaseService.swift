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
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .invalidCredential:
                                result(401)
                            case .emailAlreadyInUse:
                                result(409)
                            default:
                                result(500)
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
                                result(500)
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
    
    func listenToOrderStatus(){
        let ref = Database.database().reference().child(UserData.mobileNumber)
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if !snapshot.exists() {
                    return
            }
            var data = snapshot.value as! [String: Any]
            for (key,value) in data{
                let statusData = value as! [String:Any]
                var orderStatusData:StatusData=StatusData()
                orderStatusData.orderId=statusData["orderId"] as! String
                orderStatusData.status=statusData["status"] as! Int
                orderStatusData.isRecieved=statusData["isRecieved"] as! Bool
                if orderStatusData.status == 0 && orderStatusData.status == 3{
                    if orderStatusData.isRecieved == false{
                        self.notificationService.pushNotification(orderId: orderStatusData.orderId, orderStatus: orderStatusData.status){
                            result in
                            if result == true{
                                self.markOrderAsRecieved(orderStatusData: orderStatusData,key: key)
                            }
                        }
                    }
                }
            }
        })
    }
    
    func addNewOrderStatus(order:Order){
        var statusData:StatusData=StatusData()
        statusData.status=order.status
        statusData.isRecieved=false
        statusData.orderId=order.orderId
        var orderData = statusData.asDictionary
        let ref = Database.database().reference().child(UserData.mobileNumber).child(order.orderId)
        ref.setValue(orderData)
    }
    
    func updateOrderStatus(orderId:String,status:Int){
        let ref = Database.database().reference().child(UserData.mobileNumber).child(orderId)
        ref.updateChildValues(["status":status,"isRecieved":false])
    }
    
    func markOrderAsRecieved(orderStatusData:StatusData,key:String){
        orderStatusData.isRecieved=true
        print("Updating order status")
        let ref = Database.database().reference().child(UserData.mobileNumber).child(key).setValue(orderStatusData.asDictionary)
    }
    
}
