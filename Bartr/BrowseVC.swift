//
//  BrowseVC.swift
//  Bartr
//
//  Created by Sarmed Chaudhry on 8/2/17.
//  Copyright © 2017 Sarmed Chaudhry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class BrowseVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var navDrawerBtn: UIBarButtonItem!
    let locationManager = CLLocationManager()
    var locValue:CLLocationCoordinate2D!
    var distance:CLLocationDistance = 1000.0
    var prevLocation:CLLocation!
    var totalDistanceMoved:CLLocationDistance = 0.0
    
    var currUserLocation: FIRDatabaseReference!
    let locationPost = DataService.ds.REF_LOCATIONS.child(DataService.ds.REF_CURRENT_USER.key)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navDrawerBtn.target = self.revealViewController()
        navDrawerBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        locationManager.delegate = self;
        //locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //get the locations and sift through them
        //set up table stuff with the results
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        if locations.count > 1 {
            prevLocation = locations[1]
        } else {
            print("TOOP: location count \(locations.count)")
            prevLocation = locations[0]
            
            let newLocation: Dictionary<String, AnyObject> = [
                "latitude": "\(location.coordinate.latitude)" as AnyObject,
                "longitude": "\(location.coordinate.longitude)" as AnyObject,
                "online": true as AnyObject
            ]
            //setLocationInDB(location: location)
            print("TOOP: ref cur user \(DataService.ds.REF_CURRENT_USER.key)")
            locationPost.setValue(newLocation)
            return
        }
        
        print("TOOP: location \(location.coordinate)")
        
        let distanceMoved = prevLocation.distance(from: location)
        totalDistanceMoved = totalDistanceMoved + distanceMoved
        
        print("TOOP: distance moved \(distanceMoved)")
        print("TOOP: distance moved \(totalDistanceMoved)")
        
        if totalDistanceMoved > distance {
           locationPost.updateChildValues(
                ["latitude": "\(location.coordinate.latitude)",
                 "longitude": "\(location.coordinate.longitude)",
                 "online": true]
            )
            totalDistanceMoved = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
//    func setupData() {
//        
////         1. check if system can monitor regions
//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//            
//            // 2. region data
//            let title = "Current Location"
//            let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
//            let regionRadius = 300.0
//            
//            // 3. setup region
//            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
//                                                                         longitude: coordinate.longitude), radius: regionRadius, identifier: title)
//            locationManager.startMonitoring(for: region)
//            
//            // 4. setup annotation
////            let restaurantAnnotation = MKPointAnnotation()
////            restaurantAnnotation.coordinate = coordinate;
////            restaurantAnnotation.title = "\(title)";
////            mapView.addAnnotation(restaurantAnnotation)
//            
//            // 5. setup circle
////            let circle = MKCircle(centerCoordinate: coordinate, radius: regionRadius)
////            mapView.addOverlay(circle)
//        }
//        else {
//            print("System can't track regions")
//        }
//    }
}
