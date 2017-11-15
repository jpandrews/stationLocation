//
//  ViewController.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/13/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
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

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) 
    {
        if sender.state == .ended
        {
            let tapPoint = sender.location(in: self.mapView)
            let mapCoord = self.mapView.convert(tapPoint, toCoordinateFrom: self.mapView)
            print("User tap @\(mapCoord.latitude) \(mapCoord.longitude), creating annotation...")
            
            let locationNote = LocationAnnotation.init(mapCoord)
            locationNote.delegate = self
            self.mapView.addAnnotation(locationNote)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.identifier{
            if segue == "stationList"{
                
            }
        }
    }
}

// MARK:- Delegate Setup
extension ViewController : MKMapViewDelegate , LocationAnnotationDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annotationIdentifier = "tapNote"
        var annotationView : MKPinAnnotationView
        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView {
            annotationView = dequeView
        }else{
            annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
        }
        annotationView.annotation = annotation

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationAnnotation{
            annotation.fetchLocationData()
//            // uncomment to simulate network delay
//            let delay = DispatchTimeInterval.seconds(2)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
//                annotation.fetchLocationData()
//            })
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // detail view tapped
        if view.rightCalloutAccessoryView == control{
            self.performSegue(withIdentifier: "stationList", sender: view)
        }
    }
    
    func didFinishLoadingLocationAnnotation(_ locationAnnotation: LocationAnnotation) {
        // refresh the MKAnnotationView with the new location annotation
        let view = self.mapView.view(for: locationAnnotation)
        view?.annotation = nil
        view?.annotation = locationAnnotation
    }
}

