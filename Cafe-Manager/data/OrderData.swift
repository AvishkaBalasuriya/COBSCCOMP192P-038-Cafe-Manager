//
//  OrderData.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-28.
//

import Foundation

struct OrderData {
    static var orderList:[Order] = []
}

func populateOrderList(orders:[Order]){
    OrderData.orderList=orders
}
