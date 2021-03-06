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
    var items:[Cart]
    var total:Float
    var status:Int
    var timestamp:Date
    var userId:String
    
    init(orderId:String,userEmailAddress:String,items:[Cart],total:Float,status:Int,userId:String,timestamp:Date=Date()) {
        self.orderId=orderId
        self.userEmailAddress=userEmailAddress
        self.items=items
        self.total=total
        self.status=status
        self.timestamp=timestamp
        self.userId=userId
    }
}

class StatusData: NSObject {
    var orderId:String=""
    var status:Int=0
    var isRecieved:Bool=false
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        return dict
      }
}
