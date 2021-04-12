//
//  firestoreDataService.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-11.
//

import UIKit
import FirebaseFirestore

class firestoreDataService: NSObject {
    
    let db = Firestore.firestore()
    
    func addUserToFirestore(user:User,result: @escaping (_ authResult: Int?)->Void){
        let ref = db.collection("users")
        ref.document(user.emailAddress).setData([
            "emailAddress": user.emailAddress,
            "mobileNumber": user.mobileNumber,
            "type":user.type
        ]) { err in
            if err != nil{
                result(500)
            } else {
                result(201)
            }
        }
    }
    
    func fetchUser(user:User,completion: @escaping (Any)->()){
        let docRef = db.collection("users").document(user.emailAddress)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let user = User()
                user.emailAddress=document.get("emailAddress") as! String
                user.mobileNumber=document.get("mobileNumber") as! String
                user.type=document.get("type") as! Int
                completion(user)
            } else {
                completion(404)
            }
        }
    }
    
    func getAllOrders(status:Int,completion: @escaping (Any)->()){
        var orders:[Order] = []
        db.collection("orders").whereField("status", isEqualTo: status).getDocuments(){
            (querySnapshot, err) in
           if let err = err {
                completion(500)
           } else {
                for document in querySnapshot!.documents {
                    let orderId:String=document.data()["orderId"] as! String
                    let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                    var items:[String]=[]
                     for item in document.data()["items"] as! [String]{
                         items.append(item)
                     }
                    let total:Float=document.data()["total"] as! Float
                    let status:Int=document.data()["status"] as! Int
                    orders.append(Order(orderId: orderId, userEmailAddress: userEmailAddress, items: items, total: total, status: status))
                }
                 completion(orders)
           }
        }
    }
    
    func changeOrderStatus(orderId:String, status:Int, completion: @escaping (Any)->()){
        db.collection("orders").document(orderId).updateData(["status":status]){
            err in
            if let err = err {
                completion(500)
            } else {
                completion(204)
            }
        }
    }
    
    func addNewItem(item:Item, completion: @escaping (Any)->()){
        db.collection("items").document(item.itemId).setData([
            "itemId":item.itemId,
            "itemName":item.itemName,
            "itemDescription":item.itemDescription,
            "itemThumbnail":item.itemThumbnail,
            "itemPrice":item.itemPrice,
            "itemDiscount":item.itemDiscount,
            "isAvailable":item.isAvailable
        ]){ err in
            if err != nil{
                completion(500)
            } else {
                completion(201)
            }
        }
    }
    
    func getAllItems(completion: @escaping (Any)->()){
        var items:[Item]=[]
        db.collection("items").getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                completion(500)
            }else{
                for document in querySnapshot!.documents {
                    let itemId=document.data()["itemId"] as! String
                    let itemName=document.data()["itemName"] as! String
                    let itemDescription=document.data()["itemDescription"] as! String
                    let itemThumbnail=document.data()["itemThumbnail"] as! String
                    let itemPrice=document.data()["itemPrice"] as! Float
                    let itemDiscount=document.data()["itemDiscount"] as! Float
                    let isAvailable=document.data()["isAvailable"] as! Bool
                    items.append(Item(itemId: itemId, itemName: itemName, itemThumbnail: itemThumbnail, itemDescription: itemDescription, itemPrice: itemPrice,itemDiscount: itemDiscount,isAvailable: isAvailable))
                }
                completion(items)
            }
        }
    }
    
    func updateItemAvailability(itemId:String,isAvailable:Bool,completion: @escaping (Any)->()){
        db.collection("items").document(itemId).updateData(["isAvailable":isAvailable]){
            err in
            if let err = err {
                completion(500)
            } else {
                completion(204)
            }
        }
    }

}
