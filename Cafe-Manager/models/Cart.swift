//
//  Cart.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-28.
//

import UIKit

class Cart: NSObject {
    var itemId:String
    var itemName:String
    var itemQty:Int
    var itemPrice:Float
    var totalPrice:Float
    
    init(itemId:String,itemName:String,itemQty:Int,itemPrice:Float,totalPrice:Float) {
        self.itemId=itemId
        self.itemName=itemName
        self.itemQty=itemQty
        self.itemPrice=itemPrice
        self.totalPrice=totalPrice
    }
}

