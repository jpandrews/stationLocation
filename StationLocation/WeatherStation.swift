//
//  WeatherStation.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/14/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import Foundation
import MapKit

class WeatherStation: NSObject , MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    init(_ location:CLLocationCoordinate2D){
        coordinate = location
    }
}
