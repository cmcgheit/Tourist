//
//  MapVC.swift
//  Tourist
//
//  Created by C McGhee on 4/3/17.
//  Copyright © 2017 C McGhee. All rights reserved.

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import Pulley
// import STLocationRequest

class MapVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet var controlsContainer: UIView!
    @IBOutlet var temperatureLabel: UILabel!
    
    @IBOutlet var temperatureLabelBottomConstraint: NSLayoutConstraint!
    fileprivate let temperatureLabelBottomDistance: CGFloat = 8.0
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var directionsBtn: UIButton!
    @IBOutlet weak var streetViewBtn: UIButton!
    @IBOutlet weak var pinTurnBtn: UIButton!
    @IBOutlet weak var getUserLocationBtn: UIButton!
    
    @IBOutlet weak var directionsDetail: UILabel!
    @IBOutlet weak var stlLocationBtn: UIButton!
    
    var marker = GMSMarker()
    var rectangle = GMSPolyline()
    
    // Location Manager properties
    weak var locationManagerDelegate: LocationManagerDelegate?
    let locationManager = CLLocationManager()
    
    let addressQueue = DispatchQueue(label: "address-queue")
    let directionsQueue = DispatchQueue(label: "directions-queue")
    
    // Favorite Places properties
    var currentRecommendedPlace: RecommendedPlaces?
    var coordinate: CLLocationCoordinate2D?
    let directionService = DirectionService()
    var travelMode = TravelModes.driving
    
    var originLatitude: Double = 10.773434
    var originLongtitude: Double = 106.683509
    var originLatitudeDefault: Double = 0
    var originLongtitudeDefault: Double = 0
    var destinationLatitude: Double = 10.775459
    var destinationLongtitude: Double = 106.681476
    var checkClick: Int = 0
    
    var isStatusBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlsContainer.layer.cornerRadius = 10.0
        temperatureLabel.layer.cornerRadius = 7.0
        
        mapView.delegate = self
        self.view.bringSubviewToFront(controlsContainer)
        self.view.bringSubviewToFront(temperatureLabel)
        
        // MARK: - CoreLocation/User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        zoomToUserLocation()
        }
        
        // Button Tint
        searchButton.tintColor = UIColor.darkGray
        directionsBtn.tintColor = UIColor.darkGray
        pinTurnBtn.tintColor = UIColor.darkGray
        streetViewBtn.tintColor = UIColor.darkGray
        getUserLocationBtn.tintColor = UIColor.darkGray
        // stlLocationBtn.tintColor = UIColor.darkGray
        
        // Hide Status Bar when view loads
        hideStatusBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showStatusBar()
        
        // Pulley layout for iPhone/iPad
        self.pulleyViewController?.displayMode = .automatic
        
        // Remove navi bar from all screens
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Status Bar Animation Functions
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func hideStatusBar() {
        isStatusBarHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func showStatusBar() {
        isStatusBarHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    // MARK: - Zoom Function
    func zoomToUserLocation() {
        checkLocationServicePermission()
        let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        // print("locations = \(locValue.latitude) \(locValue.longitude)") // actual coordindate
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude))
        mapView.setMinZoom(10, maxZoom: 20)
        
    }
    
    // MARK: - Get Users Location Function (Turn Location into Address)
    func getAddress(address:String){
        
        let key: String = Constants.Google_Maps.apiKey
        let postParameters: [String: Any] = [ "address": address,"key":key]
        let url: String = "https://maps.googleapis.com/maps/api/geocode/json"
        
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
        marker.icon = UIImage(named:"")
        marker.map = self.mapView
        let marker1 = GMSMarker(position: CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongtitude))
        marker1.icon = UIImage(named:"")
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
        directionsQueue.async {
            self.makeDirections()
        }
        self.afterDirection()
    }
    
    @IBAction func driving(_ sender: Any) {
        self.travelMode = TravelModes.driving
        directionsQueue.async {
            self.makeDirections()
        }
        self.afterDirection()
    }
    
    @IBAction func transit(_ sender: Any) {
        self.travelMode = TravelModes.transit
        directionsQueue.async {
            self.makeDirections()
        }
        self.afterDirection()
    }
    
    fileprivate func afterDirection() {
        self.directionService.totalDistanceInMeters = 0
        self.directionService.totalDurationInSeconds = 0
        self.directionService.selectLegs.removeAll()
        self.directionService.selectSteps.removeAll()
        
    }
    
    @IBAction func searchTransition(sender: AnyObject) {
        let searchViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchDrawerVC")
        self.pulleyViewController?.setPrimaryContentViewController(controller: searchViewVC, animated: true)
    }
    
    // MARK: - StreetView Function
    func loadStreetView() {
        checkLocationServicePermission()
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        
        panoView.moveNearCoordinate(coordinate!) //Move toward places coordinate
        panoView.animate(to: GMSPanoramaCamera(heading: 90, pitch: 0, zoom: 1), animationDuration: 2)
    }
    
    // MARK: - Turn by Turn Button Action
    @IBAction func turnByTurnBtnPressed(_ sender: UIButton) {
        checkLocationServicePermission()
        
    }
    
    // MARK: - Street View Button Action
    @IBAction func streetViewBtnPressed(_ sender: UIButton) {
        checkLocationServicePermission()
        loadStreetView()
    }
    
    // MARK: - Get User Location Button Action
    @IBAction func getLocationBtnPressed(_ sender: UIButton) {
        checkLocationServicePermission()
        let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        let getUserLocation = "\(locValue.latitude) \(locValue.longitude)"
        
        addressQueue.async {
            self.getAddress(address: getUserLocation)
        }
    }
    
    // MARK: - STL Location Button Action
    @IBAction func startSTLLocationRequestBtnPressed(_ sender: UIButton) {
        checkLocationServicePermission()
        // let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        // locationRequestController.addPlace(latitude: "\(locValue.latitude)", longitude: "\(locValue.longitude)")
    }
    
    // MARK: - Fade Animation Transition
    func fadeAnimation() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            self.mapView.alpha = 0.0
            self.controlsContainer.alpha = 0.0
            self.temperatureLabel.alpha = 0.0
        }).startAnimation()
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
                locationManager.stopUpdatingLocation()
                Alert.presentLocationAlert(delegate: self, message: "Location Access Denied - Please go to settings and enable location services")
            } else {
                if CLLocationManager.authorizationStatus() == .notDetermined{
                    // Present the STLocationRequestController
                    presentLocationRequestController()
                    Alert.presentLocationAlert(delegate: self, message: "Location Access Not Determined - Please check your location settings")
                } else {
                    // The user has already allowed your app to use location services. Start updating location
                    locationManager.startUpdatingLocation()
                }
            }
        } else {
            // Location Services are disabled
            locationManager.stopUpdatingLocation()
            Alert.presentLocationAlert(delegate: self, message: "Location Services Disabled - Please go to settiings and enable location services")
        }
    }
}

// MARK: Street View Extension
extension MapVC: GMSPanoramaViewDelegate {
    
    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print(error.localizedDescription)
    }
}

// MARK: - Pulley Drawer
extension MapVC: PulleyPrimaryContentControllerDelegate {
    
    func makeUIAdjustmentsForFullscreen(progress: CGFloat, bottomSafeArea: CGFloat) {
        guard let drawer = self.pulleyViewController, drawer.currentDisplayMode == .drawer else {
            controlsContainer.alpha = 1.0
            return
        }
        
        controlsContainer.alpha = 1.0 - progress
    }
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        guard drawer.currentDisplayMode == .drawer else {
            temperatureLabelBottomConstraint.constant = temperatureLabelBottomDistance
            return
        }
        
        if distance <= 268.0 + bottomSafeArea {
            temperatureLabelBottomConstraint.constant = distance + temperatureLabelBottomDistance
        } else {
            temperatureLabelBottomConstraint.constant = 268.0 + temperatureLabelBottomDistance
        }
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
//            Alert.presentLocationAlert(delegate: self, message: "Location Access Denied - Please go to settings and enable location services")
//        case .notNowButtonTapped:
//            Alert.presentLocationAlert(delegate: self, message: "Location Access: Not Now Selected - Please go to settings and enable location services")
//        case .didPresented:
//            print("STLocationRequestController did presented")
//        case .didDisappear:
//            print("STLocationRequestController did disappear")
//        }
//    }
//}

// MARK: - CLLocationManagerDelegate
extension MapVC: CLLocationManagerDelegate {
    
    // CLLocationManagerDelegate DidFailWithError Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Alert.presentLocationAlert(delegate: self, message: "Location Error - No Location Found")
        print("Error. The Location couldn't be found. \(error)")
    }
    
    // CLLocationManagerDelegate didUpdateLocations Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1] // last location locations.last
        if location.horizontalAccuracy < 0 { // stop updating location once get valid result
            print("didUpdateLocations UserLocation: \(String(describing: locations.last))") // location.coordinate.latitude/longitude
            self.locationManager.stopUpdatingLocation()
            locationManager.delegate = nil // get location data once
        }
    }
}





