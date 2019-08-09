//
//  LocationVC.swift
//  Treads
//
//  Created by Odhrán Daly on 09/08/2019.
//  Copyright © 2019 Odhrán Daly. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController, MKMapViewDelegate {
    
    var manager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
        
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager?.requestWhenInUseAuthorization()
        }
    }
}
