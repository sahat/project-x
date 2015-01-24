//
//  FirstViewController.swift
//  Tesla
//
//  Created by Sahat Yalkabov on 1/13/15.
//  Copyright (c) 2015 Sahat Yalkabov. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UITabBar.appearance().translucent = true
        
        let location = CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Big ben"
        annotation.subtitle = "LONDON"
        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

