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

    var regionDelegate: SquareRegionDelegate!

    var mapView: MKMapView!

    /// This is the example project
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         setupLocation()
        setupMap()
        setupData()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {

            Helpers.showAlert("Location services were previously denied. Please enable location services for this app in Settings.", sender: self)
        }
            // we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }




    func setupMap(){

        // setup mapView
        mapView = MKMapView.init(frame: view.frame)
        mapView.delegate = self
        mapView.showsUserLocation = true

        view.addSubview(mapView)
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
         mapView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        let region = MKCoordinateRegion.init(center:  CLLocationCoordinate2D.init(latitude:  37.788381, longitude:  -122.408937), latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
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



        let steakHouseCoordinate = CLLocationCoordinate2D.init(latitude:  37.788381, longitude:  -122.408937)


        let bankCoordinate = CLLocationCoordinate2D.init(latitude:   37.788867, longitude: -122.408769)

        let nailSalonCoordinate = CLLocationCoordinate2D.init(latitude: 37.789302, longitude: -122.408985)

        // setup regions
        let steakHouseRegion = CKSquareRegion.init(regionWithCenter: steakHouseCoordinate, sideLength: 0.025, identifier: "steakHouse", onEntry: true, onExit: true)
        let bankRegion = CKSquareRegion.init(regionWithCenter: bankCoordinate, sideLength: 0.025, identifier: "bank", onEntry: false, onExit: true)
        let nailSalonRegion =  CKSquareRegion.init(regionWithCenter: nailSalonCoordinate, sideLength: 0.025, identifier: "nailSalon", onEntry: true, onExit: false)


        // add region to monitor
        regionDelegate.addRegionToMonitor(region: steakHouseRegion!)
        regionDelegate.addRegionToMonitor(region: bankRegion!)
        regionDelegate.addRegionToMonitor(region: nailSalonRegion!)

        let steakHousePoint = [
            CLLocationCoordinate2D.init(latitude:  37.788477, longitude:  -122.409054),
            CLLocationCoordinate2D.init(latitude: 37.788503, longitude:  -122.408864),
            CLLocationCoordinate2D.init(latitude:  37.788324, longitude: -122.408806),
            CLLocationCoordinate2D.init(latitude:  37.788301, longitude:  -122.409003)]
        let bankPoint = [
            CLLocationCoordinate2D.init(latitude:  37.788854, longitude: -122.408652),
            CLLocationCoordinate2D.init(latitude: 37.788941, longitude:  -122.408683),
            CLLocationCoordinate2D.init(latitude: 37.788917, longitude: -122.408880),
            CLLocationCoordinate2D.init(latitude: 37.788826, longitude: -122.408865)
                        ]
        let nailSalonPoint = [
            CLLocationCoordinate2D.init(latitude:  37.789337, longitude: -122.409075),
            CLLocationCoordinate2D.init(latitude:  37.789349, longitude: -122.408925),
            CLLocationCoordinate2D.init(latitude:  37.789261, longitude:  -122.408875),
            CLLocationCoordinate2D.init(latitude:  37.789247, longitude: -122.409059)]

        let bankPolygon = MKPolygon.init(coordinates: bankPoint, count: 4)
        let steakHousePolygon = MKPolygon.init(coordinates: steakHousePoint, count: 4)
        let nailSalonPolygon = MKPolygon.init(coordinates: nailSalonPoint, count: 4)

        mapView.addOverlays([bankPolygon,nailSalonPolygon,steakHousePolygon])
        

        // setup anotation
        let steakHouseAnnotation = MKPointAnnotation()
        steakHouseAnnotation.coordinate = steakHouseCoordinate
        steakHouseAnnotation.title = "SteakHouse"

        let bankAnnotation = MKPointAnnotation()
        bankAnnotation.coordinate = bankCoordinate
        bankAnnotation.title = "Bank of America"

        let nailSalonAnnotation = MKPointAnnotation()
        nailSalonAnnotation.coordinate = nailSalonCoordinate
        nailSalonAnnotation.title = "nails Salon"

        mapView.addAnnotations([steakHouseAnnotation,bankAnnotation,nailSalonAnnotation])
    }
}

extension ViewController: MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let polygonView = MKPolygonRenderer(overlay: overlay)
        polygonView.fillColor = UIColor(red: 0, green: 0.847, blue: 1, alpha: 0.25)

        return polygonView
    }
}

extension ViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
        regionDelegate.updateRegion(location: location)
        }
    }
}
extension ViewController: SquareRegionDelegate{

    func didEnterRegion(region: CKSquareRegion) {

        let message = "welcome to \(region.identifier ?? "")"
        Helpers.showAlert("enter region", sender: self, message: message)

        print("*** enter \(region.identifier ?? "") ****")
    }

    func didExitRegion(region: CKSquareRegion) {


        let message = "The \(region.identifier  ?? "") was happy to see you too, Bye"
        Helpers.showAlert("leave region", sender: self, message: message)
         print("*** leave \(region.identifier  ?? "") ****")

    }

}
