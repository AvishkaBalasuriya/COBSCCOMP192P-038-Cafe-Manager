//
//  LocationService.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-12.
//

import UIKit
import CoreLocation

class LocationService: NSObject {
    
    let locationManager = CLLocationManager()
    
    func getGpsLocation(){
        
        let currentLoc = locationManager.location?.coordinate
        print(currentLoc!.latitude)
        print(currentLoc!.longitude)
        
    }
}
