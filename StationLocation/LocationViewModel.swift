//
//  LocationViewModel.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/14/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationViewModel {
    
    // Origin Center and Size will frame CA
    var origin:(center:CLLocationCoordinate2D,regionSize:CLLocationDistance) {
        get{
            // CA Approx Center ~ lat:37 long:-119
            let startingCoordinate = CLLocationCoordinate2D(latitude:37 ,longitude: -119)
            let regionDistance: CLLocationDistance = 1240000 // CA.length in meters
            return (startingCoordinate ,regionDistance)
        }
    }
    
    // 
    func fetchDataForLocationAnnotation(_ locationAnnotation:LocationAnnotation, withHandler completionHandler:@escaping () -> Void){
//        // uncomment to simulate network delay
//        let delay = DispatchTime.now() + DispatchTimeInterval.seconds(2)
//        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
        
        // fetch already complete or in progress, abort
        if locationAnnotation.placemark != nil || locationAnnotation.placemarkLoading {
            return
        }
        locationAnnotation.placemarkLoading = true
        
        let location = CLLocation.init(latitude: locationAnnotation.coordinate.latitude,
                                       longitude: locationAnnotation.coordinate.longitude)
        //
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let placemark: CLPlacemark = placemarks?.first{
                locationAnnotation.placemark = placemark
                locationAnnotation.placemarkLoading = false
                completionHandler()
            }
        })
//        }) // dispatch block
    }
    
    //
    func loadWeatherStationsAtLocation(_ location:CLLocationCoordinate2D, withHandler completionHandler:@escaping (WundergroundQueryResult?) -> Void)
    {
        let query = WundergroundQuery.init(withLatitude:location.latitude,
                                           longitude: location.longitude)
        guard let queryURL = query.URL else {
            // invalid URL error
            completionHandler(nil)
            return
        }
        print(queryURL.absoluteString)
        // Simple URL request can use the shared session configuration
        URLSession.shared.dataTask(with: queryURL) { (data, response, error) in
            if error != nil {
                // perhaps pass along the error the UI to inform user, not now though.
                completionHandler(nil)
                return
            }
            let result = WundergroundQueryResult.init(withJSONData:data!)
            completionHandler(result)
        }.resume()
    }
}
