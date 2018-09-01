//SearchVC.swift, created with love by C McGhee

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class SearchVC: UIViewController {
    
    // @IBOutlet weak var searchTextFld: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    var locationManager = CLLocationManager()
    var searchPlace: RecommendedPlaces?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // requestLocation()
        
        // searchTextFld.delegate = self
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    // MARK: - Google AutoComplete Search Functions
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        let lat = place.coordinate.latitude
//        let long = place.coordinate.longitude
//        let location = (lat, long)
//        print(location)
//        // showPartyMarkers(lat: lat, long: long)
//
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
//        mapView.camera = camera
//        searchTextFld.text = place.formattedAddress
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        searchPlace = RecommendedPlaces(name: place.formattedAddress!, address: place.formattedAddress!, location: marker.position, zoom: 150)
//        marker.title = "\(place.name)"
//        marker.snippet = "\(place.formattedAddress!)"
//        marker.map = mapView
//
//        self.dismiss(animated: true, completion: nil) // dismiss after place selected
//    }
    

//    func initGoogleMaps() {
//        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
//        self.mapView.camera = camera
//        self.mapView.delegate = self
//        self.mapView.isMyLocationEnabled = true
//    }
}

// MARK: - Search Bar Extension (for Google Auto Complete)
public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let mapTextField = (svs.filter { $0 is UITextField }).first as? UITextField else { return } // Call from favorite markers?
        mapTextField.textColor = color
    }
}

//extension SearchVC: UITextFieldDelegate {
//
//    //MARK: - Search TextField Delegate Functions
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        let autoCompleteController = GMSAutocompleteViewController()
//        autoCompleteController.delegate = self
//
//        let filter = GMSAutocompleteFilter()
//        autoCompleteController.autocompleteFilter = filter
//
//        self.present(autoCompleteController, animated: true, completion: nil)
//        return false
//    }
//}

// Handle the user's selection.
extension SearchVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//// MARK: - CLLocationManagerDelegate
//extension SearchVC: CLLocationManagerDelegate {
//
//    func requestLocation() {
//        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.distanceFilter = 10
//        locationManager.delegate = self
//        locationManager.requestLocation()
//    }
//
//    func deniedLocationAccess() {
//        let alertController = UIAlertController(title: "Location Access Denied", message: "Location Information is needed to show location information", preferredStyle: .alert)
//        let openAction = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
//            if let url = URL(string: UIApplicationOpenSettingsURLString) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
//        alertController.addAction(openAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    func restrictedLocationAccess() {
//        let alertController = UIAlertController(title: "Location Access Restricted", message: "Location Access Restricted, Please enable full location access in parental controls", preferredStyle: .alert)
//        let openAction = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
//            if let url = URL(string: UIApplicationOpenSettingsURLString) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
//        alertController.addAction(openAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    // when authorization status changes...
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//            break
//        case .authorizedWhenInUse:
//            manager.startUpdatingLocation()
//            break
//        case .authorizedAlways:
//            manager.startUpdatingLocation()
//            break
//        case .restricted:
//            // restricted by e.g. parental controls. User can't enable Location Services
//            restrictedLocationAccess()
//            break
//        case .denied:
//            // user denied your app access to Location Services, but can grant access from Settings.app
//            deniedLocationAccess()
//            break
//        }
//    }
//
//
//    // CLLocationManagerDelegate DidFailWithError Methods
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error. The Location couldn't be found. \(error)")
//    }
//
//    // CLLocationManagerDelegate didUpdateLocations Methods
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        manager.stopUpdatingLocation()
//        print("didUpdateLocations UserLocation: \(String(describing: locations.last))")
//    }
//
//}

