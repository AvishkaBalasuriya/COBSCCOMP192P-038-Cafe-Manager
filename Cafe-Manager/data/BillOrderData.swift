//
//  BillOrderData.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-29.
//

import Foundation

struct BillOrderData {
    static var billOrderList:[Order] = []
}

func populateBillOrderList(orders:[Order]){
    BillOrderData.billOrderList=orders
}
