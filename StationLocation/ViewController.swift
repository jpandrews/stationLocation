//
//  ViewController.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/13/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
            self.setupInitialMapLocation()
        }
    }
    
    private func setupInitialMapLocation(){
        // CA Approx Center ~ lat:37 long:-119
        let startingCoordinate = CLLocationCoordinate2D(latitude:37 ,longitude: -119)
        mapView.centerCoordinate = startingCoordinate ;
        
        // length of CA in meters
        let regionDistance: CLLocationDistance = 1240000
        let region = MKCoordinateRegionMakeWithDistance(startingCoordinate, regionDistance, regionDistance)
        mapView.region = region ;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) 
    {
        if sender.state == .ended
        {
            let tapPoint = sender.location(in: self.mapView)
            let mapCoord = self.mapView.convert(tapPoint, toCoordinateFrom: self.mapView)
            print("User tap @\(mapCoord.latitude) \(mapCoord.longitude)")
        }
    }
    
    

}

