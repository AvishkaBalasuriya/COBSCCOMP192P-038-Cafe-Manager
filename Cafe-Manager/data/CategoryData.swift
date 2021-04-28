//
//  CategoryData.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-28.
//

import Foundation

struct CategoryData {
    static var categoryList:[Category] = []
}

func populateCategoryList(categories:[Category]){
    CategoryData.categoryList=categories
}
