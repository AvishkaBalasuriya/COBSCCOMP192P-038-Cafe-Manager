//
//  GpsLocation.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-12.
//

import UIKit

class GpsLocation: NSObject {

    var latitude:Float
    var longitude:Float
    
    init(latitude:Float,longitude:Float){
        self.latitude=latitude
        self.longitude=longitude
    }
    
}
