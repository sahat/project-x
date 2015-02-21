//
//  FirstViewController.swift
//  Tesla
//
//  Created by Sahat Yalkabov on 1/13/15.
//  Copyright (c) 2015 Sahat Yalkabov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var route: MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        mapView.setRegion(MKCoordinateRegionMake(p2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
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
        myLineRenderer.strokeColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.6)
        myLineRenderer.lineWidth = 5
        return myLineRenderer
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
    
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            locationManager.stopUpdatingLocation()
            
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

