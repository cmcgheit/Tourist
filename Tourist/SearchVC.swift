//SearchVC.swift, created with love by C McGhee

import UIKit
import GoogleMaps
import GooglePlaces
// import CoreLocation

class SearchVC: UIViewController, GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchTextFld: UITextField!
    @IBOutlet weak var headerView: UIView!
    
     var searchPlace: RecommendedPlaces?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Location Manager properties
//        weak var locationManagerDelegate: LocationManagerDelegate?
//        let locationManager = CLLocationManager()
        
        mapView.delegate = self
        searchTextFld.delegate = self
        
    }
    
    //MARK: - Search TextField Delegate Functions
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        // self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }

    // MARK: - Google AutoComplete Search Functions
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        let location = (lat, long)
        print(location)
        // showPartyMarkers(lat: lat, long: long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        mapView.camera = camera
        searchTextFld.text = place.formattedAddress
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        searchPlace = RecommendedPlaces(name: place.formattedAddress!, address: place.formattedAddress!, location: marker.position, zoom: 150)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = mapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: Google Search: \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
    }
}

// MARK: - Search Bar Extension (for Google Auto Complete)
public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let mapTextField = (svs.filter { $0 is UITextField }).first as? UITextField else { return } // Call from favorite markers?
        mapTextField.textColor = color
    }
}

//// MARK: - CLLocationManagerDelegate
//extension SearchVC: CLLocationManagerDelegate {
//
//    /// CLLocationManagerDelegate DidFailWithError Methods
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error. The Location couldn't be found. \(error)")
//    }
//
//    /// CLLocationManagerDelegate didUpdateLocations Methods
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.locationManager.stopUpdatingLocation()
//        print("didUpdateLocations UserLocation: \(String(describing: locations.last))")
//    }
//
//}

