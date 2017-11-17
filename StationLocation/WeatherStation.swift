//
//  WeatherStation.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/14/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import Foundation
import MapKit

class WeatherStation: NSObject , Decodable {
    
    /*
        Some properties are optional because the data is dependent on station type (airport/pws) but
     there is enough overlap I'm using the same class for both.
     */
    
    // Prevent access to raw string data, prefer .coordinate
    private var longitude: String? = nil
    private var latitude: String? = nil
    
    var neighborhood: String? = nil
    var city: String = ""
    var state: String = ""
    var country: String = ""
    
    private enum CodingKeys : String , CodingKey {
        case longitude = "lon"
        case latitude = "lat"
        case neighborhood
        case city
        case state
        case country
    }
}

extension WeatherStation: MKAnnotation
{
    var coordinate: CLLocationCoordinate2D {
        get{
            var coord = kCLLocationCoordinate2DInvalid
            if let lat = latitude , let lon = longitude {
                coord = CLLocationCoordinate2D.init(latitude: Double(lat) ?? 0 ,
                                                    longitude: Double(lon) ?? 0 )
            }
            return coord
        }
    }
}

