//
//  BeginRunVC
//  Treads
//
//  Created by Odhrán Daly on 08/08/2019.
//  Copyright © 2019 Odhrán Daly. All rights reserved.
//

import UIKit
import MapKit

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
        
        return MKPolyline(coordinates: coordinate, count: lastRun.locations.count)
    }

    @IBAction func loactionCenterBtnPressed(_ sender: Any) {
    }
    
    @IBAction func lastRunClosedBtnPressed(_ sender: Any) {
        lastRunBGView.isHidden = true
        lastRunCloseBtn.isHidden = true
        lastRunStackView.isHidden = true
    }
    
}

extension BeginRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
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
