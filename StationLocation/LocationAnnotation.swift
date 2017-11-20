//
//  LocationAnnotation.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/14/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject , MKAnnotation
{
    // store location information and loading status to limit multiple queries
    var placemark: CLPlacemark?
    var placemarkLoading = false
    
    var weatherStations: [WeatherStation]? = nil
    var currentObservation: WeatherObservation? = nil
    
    let coordinate: CLLocationCoordinate2D
    var title: String? {
        get{
            if let locality = self.placemark?.locality, let adminArea = self.placemark?.administrativeArea{
                return locality + ", " + adminArea
            }
            // force a default title or didSelect isn't called for MKAnnotationView ?
            return self.placemark?.locality ?? self.placemark?.ocean ?? "..."
        }
    }
    var subtitle: String? {
        get{
            guard let temperature = currentObservation?.temperatureF else {
                return nil
            }
            return String(temperature) + "℉"
        }
    }
    
    init(_ coordinate:CLLocationCoordinate2D){
        self.coordinate = coordinate
        super.init()
    }
}
