//
//  firestoreDataService.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-11.
//

/*
 0 - New
 1 - Preperation
 2 - Ready
 3 - Arriving
 4 - Done
 5 - Cancel
 */

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
    
    func getAllOrders(completion: @escaping (Any)->()){
        db.collection("orders").addSnapshotListener { querySnapshot, error in
            if let err = error {
                completion(500)
            }
            var orders:[Order] = []
            for document in querySnapshot!.documents {
                var cart:[Cart]=[]
                let orderId:String=document.data()["orderId"] as! String
                let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                let items = document.data()["items"] as! [Any]
                for item in items{
                    let itemData = item as! [String:Any]
                    let itemId:String = itemData["itemId"] as! String
                    let itemName:String = itemData["itemName"] as! String
                    let itemQty:Int = itemData["itemQty"] as! Int
                    let itemPrice:Float = itemData["itemPrice"] as! Float
                    let totalPrice:Float = itemData["totalPrice"] as! Float
                    let cartItem = Cart(itemId: itemId, itemName: itemName, itemQty: itemQty, itemPrice: itemPrice, totalPrice: totalPrice)
                    cart.append(cartItem)
                }
                let total:Float=document.data()[
                    "total"] as! Float
                let status:Int=document.data()["status"] as! Int
                let timestamp:Timestamp = document.data()["timestamp"] as! Timestamp
                let userId:String = document.data()["userId"] as! String
                orders.append(Order(orderId: orderId, userEmailAddress: userEmailAddress, items: cart, total: total, status: status,userId: userId, timestamp:timestamp.dateValue()))
            }
            populateOrderList(orders: orders)
            completion(orders)
        }
    }
    
    func changeOrderStatus(orderId:String,userId:String,status:Int, completion: @escaping (Any)->()){
        db.collection("orders").document(orderId).updateData(["status":status]){
            err in
            if let err = err {
                completion(500)
            } else {
                FirebaseService().updateOrderStatus(orderId: orderId, status: status,userId: userId)
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
            "isAvailable":item.isAvailable,
            "category":item.category
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
                    let itemCategory=document.data()["category"] as! String
                    items.append(Item(itemId: itemId, itemName: itemName, itemThumbnail: itemThumbnail, itemDescription: itemDescription, itemPrice: itemPrice,itemDiscount: itemDiscount,isAvailable: isAvailable,category: itemCategory))
                }
                populateItemList(items: items)
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
    
    func getAllCategories(completion: @escaping (Any)->()){
        db.collection("categories").addSnapshotListener {
            querySnapshot, error in
            if let err = error {
                completion(500)
            }else{
                var categories:[Category]=[]
                for document in querySnapshot!.documents {
                    let categoryId=document.data()["categoryId"] as! String
                    let categoryName=document.data()["categoryName"] as! String
                    categories.append(Category(categoryId: categoryId, categoryName: categoryName))
                }
                populateCategoryList(categories: categories)
                completion(categories)
            }
        }
    }
    
    func addNewCategory(category:Category, completion: @escaping (Any)->()){
        db.collection("categories").document(category.categoryId).setData([
            "categoryId":category.categoryId,
            "categoryName":category.categoryName
        ]){ err in
            if err != nil{
                completion(500)
            } else {
                completion(201)
            }
        }
    }
    
    func getOrdersByDateRange(start:Date,end:Date,status:Int,completion: @escaping (Any)->()){
        var orders:[Order] = []
        db.collection("orders").whereField("status", isEqualTo: status).whereField("timestamp",isGreaterThanOrEqualTo: end).whereField("timestamp", isLessThanOrEqualTo: start).getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                completion(500)
            }else{
                for document in querySnapshot!.documents {
                    var cart:[Cart]=[]
                    let orderId:String=document.data()["orderId"] as! String
                    let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                    let items = document.data()["items"] as! [Any]
                    for item in items{
                        let itemData = item as! [String:Any]
                        let itemId:String = itemData["itemId"] as! String
                        let itemName:String = itemData["itemName"] as! String
                        let itemQty:Int = itemData["itemQty"] as! Int
                        let itemPrice:Float = itemData["itemPrice"] as! Float
                        let totalPrice:Float = itemData["totalPrice"] as! Float
                        let cartItem = Cart(itemId: itemId, itemName: itemName, itemQty: itemQty, itemPrice: itemPrice, totalPrice: totalPrice)
                        cart.append(cartItem)
                    }
                    let total:Float=document.data()[
                        "total"] as! Float
                    let status:Int=document.data()["status"] as! Int
                    let timestamp:Timestamp = document.data()["timestamp"] as! Timestamp
                    let userId:String = document.data()["userId"] as! String
                    orders.append(Order(orderId: orderId, userEmailAddress: userEmailAddress, items: cart, total: total, status: status,userId: userId,timestamp:timestamp.dateValue()))
                }
                populateBillOrderList(orders: orders)
                completion(orders)
            }
        }
    }
    
    func getOrdersByStatus(status:Int,completion: @escaping (Any)->()){
        var orders:[Order] = []
        db.collection("orders").whereField("status", isEqualTo: status).getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                completion(500)
            }else{
                for document in querySnapshot!.documents {
                    var cart:[Cart]=[]
                    let orderId:String=document.data()["orderId"] as! String
                    let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                    let items = document.data()["items"] as! [Any]
                    for item in items{
                        let itemData = item as! [String:Any]
                        let itemId:String = itemData["itemId"] as! String
                        let itemName:String = itemData["itemName"] as! String
                        let itemQty:Int = itemData["itemQty"] as! Int
                        let itemPrice:Float = itemData["itemPrice"] as! Float
                        let totalPrice:Float = itemData["totalPrice"] as! Float
                        let cartItem = Cart(itemId: itemId, itemName: itemName, itemQty: itemQty, itemPrice: itemPrice, totalPrice: totalPrice)
                        cart.append(cartItem)
                    }
                    let total:Float=document.data()[
                        "total"] as! Float
                    let status:Int=document.data()["status"] as! Int
                    let timestamp:Timestamp = document.data()["timestamp"] as! Timestamp
                    let userId:String = document.data()["userId"] as! String
                    orders.append(Order(orderId: orderId, userEmailAddress: userEmailAddress, items: cart, total: total, status: status,userId: userId,timestamp:timestamp.dateValue()))
                }
                populateBillOrderList(orders: orders)
                completion(orders)
            }
        }
    }
}
