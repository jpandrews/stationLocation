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
    
    var locationViewModel: LocationViewModel = LocationViewModel()
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
            setupInitialMapLocation()
        }
    }
    
    private func setupInitialMapLocation()
    {
        let origin = locationViewModel.origin
        mapView.centerCoordinate = origin.center ;
        mapView.region = MKCoordinateRegionMakeWithDistance(origin.center, origin.regionSize, origin.regionSize) ;
    }

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) 
    {
        if sender.state == .ended{
            // get map coordinate for touch position
            let tapPoint = sender.location(in: self.mapView)
            let mapCoord = self.mapView.convert(tapPoint, toCoordinateFrom: self.mapView)
            print("User tap @\(mapCoord.latitude) \(mapCoord.longitude), creating annotation...")
            
            // weather station fetch
            self.locationViewModel.loadWeatherStationsAtLocation(mapCoord, withHandler: { (weatherStations:[WeatherStation]) in
                for weatherStation in weatherStations{
                    self.mapView.addAnnotation(weatherStation)
                }
            })
            
            // location annotation
            let locationNote = LocationAnnotation.init(mapCoord)
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
extension ViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        var annotationView : MKAnnotationView?
        
        var viewIdentifier: String?
        if annotation is LocationAnnotation{
            viewIdentifier = "locationAnnotation"
        }
        else if annotation is WeatherStation{
            viewIdentifier = "weatherStation"
        }
        
        if let identifer = viewIdentifier{
            annotationView = self.viewForAnnotation(annotation, withIdentifier: identifer)
        }
        annotationView?.annotation = annotation
        return annotationView
    }
    
    func viewForAnnotation(_ annotation:MKAnnotation, withIdentifier identifier:String) -> MKAnnotationView?
    {
        var annotationView : MKPinAnnotationView?
        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView = dequeView
        }else{
            // custom view setup
            switch identifier{
            case "locationAnnotation":
                annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
            case "weatherStation":
                annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
            default:
                annotationView = nil
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationAnnotation
        {
            self.locationViewModel.fetchDataForLocationAnnotation(annotation, withHandler: {
                // refresh the MKAnnotationView with the new location annotation
                let view = self.mapView.view(for: annotation)
                view?.annotation = nil
                view?.annotation = annotation
            })
        }
        // Selecting a weather station annotation is not implemented
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // detail view tapped
        if view.annotation is LocationAnnotation && view.rightCalloutAccessoryView == control{
            self.performSegue(withIdentifier: "stationList", sender: view)
        }
    }
}

