//
//  BeginRunVC
//  Treads
//
//  Created by Odhrán Daly on 08/08/2019.
//  Copyright © 2019 Odhrán Daly. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class BeginRunVC: LocationVC {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lastRunCloseBtn: UIButton!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var lastRunBGView: UIView!
    @IBOutlet weak var lastRunStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpMapView()
    }
    
    func setUpMapView() {
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunBGView.isHidden = false
            lastRunCloseBtn.isHidden = false
            lastRunStackView.isHidden = false
        } else {
            lastRunBGView.isHidden = true
            lastRunCloseBtn.isHidden = true
            lastRunStackView.isHidden = true
            centerMapOnUserLoaction()
        }
    }
    
    func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = Run.getAllRuns()?.first else {
            return nil
        }
        paceLbl.text = lastRun.pace.formatTimeDurationToString()
        distanceLbl.text = "\(lastRun.distance.mettersToMiles(places: 2)) mi"
        durationLbl.text = lastRun.duration.formatTimeDurationToString()
        
        var coordinate = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPreviousRoute(locations: lastRun.locations), animated: true)
        
        return MKPolyline(coordinates: coordinate, count: lastRun.locations.count)
    }
    
    func centerMapOnUserLoaction() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnPreviousRoute(locations: List<Location>) ->MKCoordinateRegion {
        guard let initialLocation = locations.first else {
            return MKCoordinateRegion()
        }
        var minLat = initialLocation.latitude
        var minLong = initialLocation.longitude
        var maxLat = initialLocation.latitude
        var maxLong = initialLocation.longitude
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLong = min(minLong, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLong = max(maxLong, location.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4, longitudeDelta: (maxLong - minLong) * 1.4))
    }

    @IBAction func loactionCenterBtnPressed(_ sender: Any) {
        centerMapOnUserLoaction()
    }
    
    @IBAction func lastRunClosedBtnPressed(_ sender: Any) {
        lastRunBGView.isHidden = true
        lastRunCloseBtn.isHidden = true
        lastRunStackView.isHidden = true
        centerMapOnUserLoaction()
    }
    
}

extension BeginRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        renderer.lineWidth = 4
        return renderer
    }
}
