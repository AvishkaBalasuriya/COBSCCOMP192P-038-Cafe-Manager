//
//  ItemData.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-27.
//

import Foundation

struct ItemData {
    static var itemList:[Item] = []
}

func populateItemList(items:[Item]){
    ItemData.itemList=items
}
