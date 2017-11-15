//
//  LocationAnnotation.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/14/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import Foundation
import MapKit

@objc protocol LocationAnnotationDelegate {
    func didFinishLoadingLocationAnnotation(_ locationAnnotation:LocationAnnotation)
}

class LocationAnnotation: NSObject , MKAnnotation
{
    var placemark: CLPlacemark?
    
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
            return nil
        }
    }
    
    init(_ coordinate:CLLocationCoordinate2D){
        self.coordinate = coordinate
        super.init()
    }
    
    weak var delegate: LocationAnnotationDelegate?
    private var fetchInProgress = false
    //
    func fetchLocationData()
    {
        // fetch already complete or in progress, abort
        if self.placemark != nil || fetchInProgress {
            return
        }
        fetchInProgress = true
        
        let location = CLLocation.init(latitude: self.coordinate.latitude,
                                       longitude: self.coordinate.longitude)
        //
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let placemark: CLPlacemark = placemarks?.first
            {
                self.placemark = placemark
                self.delegate?.didFinishLoadingLocationAnnotation(self)
            }
        })
    }
}
