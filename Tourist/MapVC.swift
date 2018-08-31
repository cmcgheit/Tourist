//
//  MapVC.swift
//  favoritePlaces
//
//  Created by C McGhee on 4/3/17.
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
// import STLocationRequest

class MapVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var directionsDetail: UILabel!
    @IBOutlet weak var pinTurnBtn: UIButton!
    @IBOutlet weak var streetViewBtn: UIButton!
    @IBOutlet weak var getUserLocationBtn: UIButton!
    @IBOutlet weak var stlLocationBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var marker = GMSMarker()
    var rectangle = GMSPolyline()
    
    // Location Manager properties
    weak var locationManagerDelegate: LocationManagerDelegate?
    let locationManager = CLLocationManager()
    
    // Favorite Places properties
    var currentRecommendedPlace: RecommendedPlaces?
    var coordinate: CLLocationCoordinate2D?
    let directionService = DirectionService()
    var travelMode = TravelModes.driving
    
    var originLatitude: Double = 10.773434
    var originLongtitude: Double = 106.683509
    var originLatitudeDefault:Double = 0
    var originLongtitudeDefault:Double = 0
    var destinationLatitude: Double = 10.775459
    var destinationLongtitude: Double = 106.681476
    var checkClick: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - STL Location Properties
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
    }
    
    // Get Users Location (Turn Location into Address)
    func getAddress(address:String){
        
        let key : String = Google_MapsKey
        let postParameters:[String: Any] = [ "address": address,"key":key]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            
            if let receivedResults = response.result.value {
                let resultParams = JSON(receivedResults)
                print("ok ok \(resultParams)")
                print(resultParams["status"])
                print(resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue)
                print(resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue)
                self.destinationLatitude = resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue
                self.destinationLongtitude = resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue
                let place_marker = GMSMarker(position: CLLocationCoordinate2D(latitude: self.destinationLatitude, longitude: self.destinationLongtitude))
                place_marker.icon = UIImage(named:"")
                place_marker.map = self.mapView
            }
        }
    }

    fileprivate func makeDirections() {
            self.mapView.clear()
            let origin: String = "\(originLatitude),\(originLongtitude)"
            let destination: String = "\(destinationLatitude),\(destinationLongtitude)"
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongtitude))
            marker.icon = UIImage(named:"iconCustomer-20.png")
            marker.map = self.mapView
            let marker1 = GMSMarker(position: CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongtitude))
            marker1.icon = UIImage(named:"bike-20.png")
            marker1.map = self.mapView
            self.directionService.getDirections(origin: origin,
                                                destination: destination,
                                                travelMode: travelMode) { [weak self] (success) in
                                                    if success {
                                                        DispatchQueue.main.async {
                                                            self?.drawRoute()
                                                            if let totalDistance = self?.directionService.totalDistance,
                                                                let totalDuration = self?.directionService.totalDuration {
                                                                self?.directionsDetail.text = totalDistance + ". " + totalDuration
                                                                if self?.checkClick == 1{
                                                                    self?.checkClick = 0
                                                                    let str = self?.directionsDetail.text
                                                                    self?.directionsDetail.text = str! + ""
                                                                }
                                                                self?.directionsDetail.isHidden = false
                                                            }
                                                        }
                                                    } else {
                                                        print("Directions error")
                                                    }
            }
        }

    fileprivate func drawRoute() {
        for step in self.directionService.selectSteps {
            if step.polyline.points != "" {
                
                let path = GMSPath(fromEncodedPath: step.polyline.points)
                let routePolyline = GMSPolyline(path: path)
                routePolyline.strokeColor = UIColor.blue
                routePolyline.strokeWidth = 3.0
                routePolyline.map = mapView
            } else {
                return
            }
        }
    }

    // MARK: - Transit Modes Buttons
    @IBAction func bicycling(_ sender: Any) {
        self.travelMode = TravelModes.bicycling
        self.makeDirections()
        self.afterDirection()
    }
    
    @IBAction func driving(_ sender: Any) {
        self.travelMode = TravelModes.driving
        self.makeDirections()
        self.afterDirection()
    }
    
    @IBAction func transit(_ sender: Any) {
        self.travelMode = TravelModes.transit
        self.makeDirections()
        self.afterDirection()
    }
    
    fileprivate func afterDirection() {
        self.directionService.totalDistanceInMeters = 0
        self.directionService.totalDurationInSeconds = 0
        self.directionService.selectLegs.removeAll()
        self.directionService.selectSteps.removeAll()

    }
    
    // MARK: - StreetView  Properties
    func loadStreetView() {
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        
        panoView.moveNearCoordinate(coordinate!) //Move toward places coordinate
        panoView.animate(to: GMSPanoramaCamera(heading: 90, pitch: 0, zoom: 1), animationDuration: 2)
    }
    
    // MARK: - Turn by Turn Button Action
    @IBAction func turnByTurnBtnPressed(_ sender: UIButton) {
        
    }
    
    // MARK: - Street View Button Action
    @IBAction func streetViewBtnPressed(_ sender: UIButton) {
        loadStreetView()
    }
    
    // MARK: - Get User Location Button Action
    @IBAction func getLocationBtnPressed(_ sender: UIButton) {
        getAddress(address: (currentRecommendedPlace?.address)!)
        makeDirections()
    }
    
    // MARK: - STL Location Button Action
    @IBAction func startSTLLocationRequestBtnPressed(_ sender: UIButton) {
        checkLocationServicePermission()
        // locationRequestController.addPlace(latitude: 51.960665, longitude: 7.626135)
    }

// MARK: - STL Request Functions
    func presentLocationRequestController() {
        
//        // Initialize STLocationRequestController with Configuration
//        let locationRequestController = STLocationRequestController { config in
//            // Perform configuration
//            config.title.text = "We need your location for some cool flyover features"
//            config.allowButton.title = "Cool"
//            config.notNowButton.title = "Not now"
//            config.mapView.alpha = 0.9
//            config.backgroundColor = UIColor.lightGray
//            config.authorizeType = .requestWhenInUseAuthorization
//        }
//        
//        // Listen on STLocationRequestController.Event's
//        locationRequestController.onEvent = self.onEvent
//        
//        // Present STLocationRequestController
//        locationRequestController.present(onViewController: self)
        
    }

func checkLocationServicePermission() {
    if CLLocationManager.locationServicesEnabled() {
        if CLLocationManager.authorizationStatus() == .denied {
            // Location Services are denied
        } else {
            if CLLocationManager.authorizationStatus() == .notDetermined{
                // Present the STLocationRequestController
                presentLocationRequestController()
            } else {
                // The user has already allowed your app to use location services. Start updating location
            }
        }
    } else {
        // Location Services are disabled
        }
    }
}

// MARK: Street View Extension
extension MapVC: GMSPanoramaViewDelegate {
    
    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print(error.localizedDescription)
        }
}

// MARK: - STLLocation Extension
//extension MapVC {
//
//    private func onEvent(_ event: STLocationRequestController.Event) {
//        print("Retrieved STLocationRequestController.Event: \(event)")
//        switch event {
//        case .locationRequestAuthorized:
//            print("The user accepted the use of location services")
//            self.locationManager.startUpdatingLocation()
//        case .locationRequestDenied:
//            print("The user denied the use of location services")
//        case .notNowButtonTapped:
//            print("The Not now button was tapped")
//        case .didPresented:
//            print("STLocationRequestController did presented")
//        case .didDisappear:
//            print("STLocationRequestController did disappear")
//        }
//    }
//}

// MARK: - CLLocationManagerDelegate
extension MapVC: CLLocationManagerDelegate {
    
    /// CLLocationManagerDelegate DidFailWithError Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error. The Location couldn't be found. \(error)")
    }
    
    /// CLLocationManagerDelegate didUpdateLocations Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        print("didUpdateLocations UserLocation: \(String(describing: locations.last))")
    }
    
}




