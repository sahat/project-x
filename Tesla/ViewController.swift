//
//  FirstViewController.swift
//  Tesla
//
//  Created by Sahat Yalkabov on 1/13/15.
//  Copyright (c) 2015 Sahat Yalkabov. All rights reserved.
//

import UIKit
import MapKit
import Alamofire


class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView?.myLocationEnabled = true
            mapView?.settings.myLocationButton = true
            mapView?.settings.compassButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            locationManager.stopUpdatingLocation()
            
            var camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
            var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)

            var marker = GMSMarker()
            marker.position = camera.target
            marker.snippet = "Hello World"
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
            
            self.view = mapView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

