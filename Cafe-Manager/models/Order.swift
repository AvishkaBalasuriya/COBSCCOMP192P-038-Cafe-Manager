//
//  Order.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-11.
//

import UIKit

class Order: NSObject {
    var orderId:String
    var userEmailAddress:String
    var items:[String]
    var total:Float
    var status:Int
    
    init(orderId:String,userEmailAddress:String,items:[String],total:Float,status:Int) {
        self.orderId=orderId
        self.userEmailAddress=userEmailAddress
        self.items=items
        self.total=total
        self.status=status
    }
}
