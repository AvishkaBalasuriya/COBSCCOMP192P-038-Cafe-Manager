//
//  GpsLocation.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-12.
//

import UIKit

class GpsLocation: NSObject {

    var latitude:Double
    var longitude:Double
    
    init(latitude:Double,longitude:Double){
        self.latitude=latitude
        self.longitude=longitude
    }
    
    override init() {
        self.latitude=0.0
        self.longitude=0.0
    }
    
}
