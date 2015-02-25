//
//  FirstViewController.swift
//  Tesla
//
//  Created by Sahat Yalkabov on 1/13/15.
//  Copyright (c) 2015 Sahat Yalkabov. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var route: MKRoute?
    
    let superchargers = [
        Supercharger(location: "Freemont", address: "45500 Fremont Blvd, Fremont, CA 94538 - Tesla Factory", description: nil, state: "CA", country: "United States", latitude: 37.49267, longitude: -121.94409, slots: 8, rate: 120)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
        
        for sc in superchargers {
            var pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2DMake(sc.latitude, sc.longitude)
            pin.title = sc.location
            pin.subtitle = sc.address
            mapView.addAnnotation(pin)
        }
        
        var p1 = MKPointAnnotation()
        var p2 = MKPointAnnotation()
        
        p1.coordinate = CLLocationCoordinate2DMake(25.0305, 121.5360)
        p1.title = "Taipei"
        p1.subtitle = "Taiwan"
        mapView.addAnnotation(p1)
        
        p2.coordinate = CLLocationCoordinate2DMake(24.9511, 121.2358)
        p2.title = "Chungli"
        p2.subtitle = "Taiwan"
        mapView.addAnnotation(p2)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        var directionsRequest = MKDirectionsRequest()
        
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(p1.coordinate.latitude, p1.coordinate.longitude), addressDictionary: nil)
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(p2.coordinate.latitude, p2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.setSource(MKMapItem(placemark: markChungli))
        directionsRequest.setDestination(MKMapItem(placemark: markTaipei))
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        
        var directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse!, error: NSError!) -> Void in
            if error == nil {
                self.route = response.routes[0] as? MKRoute
           
                self.mapView.addOverlay(self.route?.polyline)
            } else {
                println("error")
            }
        }
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var myLineRenderer = MKPolylineRenderer(polyline: route?.polyline)
        myLineRenderer.strokeColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.8)
        myLineRenderer.lineWidth = 4
        return myLineRenderer
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        var pinView = MKAnnotationView()
        pinView.annotation = annotation
        pinView.image = UIImage(named:"icon-supercharger")
        pinView.canShowCallout = true
        return pinView
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        print("The authorization status of location services is changed to: ")
        switch CLLocationManager.authorizationStatus(){
        case .Authorized:
            println("Authorized")
        case .AuthorizedWhenInUse:
            println("Authorized when in use")
        case .Denied:
            println("Denied")
        case .NotDetermined:
            println("Not determined")
        case .Restricted:
            println("Restricted")
        default:
            println("Unhandled")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            locationManager.stopUpdatingLocation()
            var currentLocationRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.5,0.5))
            mapView.setRegion(currentLocationRegion, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
            println("Latitude = \(newLocation.coordinate.latitude)")
            println("Longitude = \(newLocation.coordinate.longitude)")
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println("Location manager failed with error = \(error)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

