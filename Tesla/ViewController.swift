//
//  FirstViewController.swift
//  Tesla
//
//  Created by Sahat Yalkabov on 1/13/15.
//  Copyright (c) 2015 Sahat Yalkabov. All rights reserved.
//

import Darwin
import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var route: MKRoute?
    
    let superchargers = [
        Supercharger(location: "Freemont", address: "45500 Fremont Blvd, Fremont, CA 94538 - Tesla Factory", description: nil, state: "CA", country: "United States", latitude: 37.49267, longitude: -121.94409, slots: 8, rate: 120),
        Supercharger(location: "Folsom", address: "13000 Folsom Blvd, Folsom, CA 95630 - Folsom Boulevard Exit 23 - Folsom Premium Outlets", description: nil, state: "CA", country: "United States", latitude: 38.64392, longitude: -121.18621, slots: 4, rate: 0),
        Supercharger(location: "Gilroy", address: "681 Leavesley Rd, Gilroy, CA 95020 - 101 at Leavesley Road - Gilroy Premium Outlets - Near Sony", description: nil, state: "CA", country: "United States", latitude: 37.02615, longitude: -121.56487, slots: 10, rate: 120),
        Supercharger(location: "Harris Ranch", address: "I-5 Exit 334, Harris Ranch Inn and Restaurant 24505 W. Dorris Ave Coalinga, CA 93210", description: nil, state: "CA", country: "United States", latitude: 36.25316, longitude: -120.23853, slots: 7, rate: 120)
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
        pinView.image = UIImage(named: "icon-supercharger")
        pinView.canShowCallout = true
   
        let calloutButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        calloutButton.addTarget(self, action: "calloutButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        pinView.rightCalloutAccessoryView = calloutButton
        
        return pinView
    }
    
    func calloutButtonPressed(sender: UIButton) {
        println("HIII")
        
    
  
        println(locationManager.location.coordinate.latitude)
    }
    
//    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
//        UITapGestureRecognizer(target: <#AnyObject#>, action: <#Selector#>)
//        println("Touched annotation")
//    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("I tapped it \(view.annotation.title)")
        
        var directionsRequest = MKDirectionsRequest()
    
        let currentLocation = MKPlacemark(coordinate: locationManager.location.coordinate, addressDictionary: nil)
        let superchargerLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(37.49267, -121.94409), addressDictionary: nil)
        
        directionsRequest.setSource(MKMapItem.mapItemForCurrentLocation())
        directionsRequest.setDestination(MKMapItem(placemark: superchargerLocation))
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

        
//        if let supercharger = find(superchargers, "Freemont") {
//            println(supercharger)
//        }
        
//        var geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(view.annotation.subtitle, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
//            if let placemark = placemarks?[0] as? CLPlacemark {
//                var a = MKPlacemark(placemark: placemark)
//                println(a.location)
//                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
//            }
//        })
        
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
            
            
            for sc in superchargers {
                var start = location.coordinate
                var end = CLLocationCoordinate2DMake(sc.latitude, sc.longitude)
                var d = harvesineDistance(start, end: end)
                println("I am \(d) miles away from supercharger in \(sc.location)")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
            println("Latitude = \(newLocation.coordinate.latitude)")
            println("Longitude = \(newLocation.coordinate.longitude)")
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println("Location manager failed with error = \(error)")
    }
    
    func harvesineDistance(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Double {
        var R = 6371;
        var dLat = DegreesToRadians(end.latitude - start.latitude)
        var dLon = DegreesToRadians(end.longitude - start.longitude)
        var lat1 = DegreesToRadians(start.latitude)
        var lat2 = DegreesToRadians(end.latitude)
        
        var a = sin(dLat / 2) * sin(dLat / 2) + sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
        var c = 2 * atan2(sqrt(a), sqrt(1 - a));

        return Double(R) * c;
    }
    
    func DegreesToRadians (value: Double) -> Double {
        return value * M_PI / 180.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

