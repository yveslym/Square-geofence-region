//
//  ViewController.swift
//  Square geofence region
//
//  Created by Yves Songolo on 2/8/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    var locationManager: CLLocationManager!

    var regionDelegate: RegionProtocol!

    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupMap()
        setupData()
        setupLocation()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - Helpers

    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)

    }


    func setupMap(){

        // setup mapView
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    func setupLocation(){
        // setup locationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        regionDelegate = self
    }



    func setupData(){

    }



}

extension ViewController: MKMapViewDelegate{

}

extension ViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {


    }
}
extension ViewController: RegionProtocol{

    func didEnterRegion(region: CKSquareRegion) {

    }

    func didExitRegion(region: CKSquareRegion) {


    }

}
