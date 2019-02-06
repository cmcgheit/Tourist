//SearchDrawerVC.swift, coded with love by C McGhee

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Pulley

class SearchDrawerVC: UIViewController {
    
    @IBOutlet weak var searchDrawerTV: UITableView!
    @IBOutlet weak var searchDrawerBar: UISearchBar!
    @IBOutlet var gripperView: UIView!
    @IBOutlet var topSeparatorView: UIView!
    @IBOutlet var bottomSeperatorView: UIView!
    @IBOutlet var gripperTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var headerSectionHeightConstraint: NSLayoutConstraint!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    var locationManager = CLLocationManager()
    var searchPlace: RecommendedPlaces?
    
    var isStatusBarHidden = false
    
    fileprivate var drawerBottomSafeArea: CGFloat = 0.0 {
        didSet {
            self.loadViewIfNeeded()
            
            // contentInset for the tableview.
            searchDrawerTV.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: drawerBottomSafeArea, right: 0.0)
        }
    }
    
    private var shouldDisplayCustomMaskExample = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gripperView.layer.cornerRadius = 2.5
        
        // requestLocation()
        
        hideStatusBar()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showStatusBar()
        
        // Pulley
        if #available(iOS 10.0, *) {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            self.pulleyViewController?.feedbackGenerator = feedbackGenerator
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(bounceDrawer), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func bounceDrawer() {
        self.pulleyViewController?.bounceDrawer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if shouldDisplayCustomMaskExample {
            let maskLayer = CAShapeLayer()
            maskLayer.path = CustomMask().customMask(for: view.bounds).cgPath
            view.layer.mask = maskLayer
        }
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

// MARK: - Pulley
extension SearchDrawerVC: PulleyDrawerViewControllerDelegate {
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 68.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 264.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {

        drawerBottomSafeArea = bottomSafeArea
        
        if drawer.drawerPosition == .collapsed {
            headerSectionHeightConstraint.constant = 68.0 + drawerBottomSafeArea
        } else {
            headerSectionHeightConstraint.constant = 68.0
        }
        
        searchDrawerTV.isScrollEnabled = drawer.drawerPosition == .open || drawer.currentDisplayMode == .panel
        
        if drawer.drawerPosition != .open {
            searchDrawerBar.resignFirstResponder()
        }
        
        if drawer.currentDisplayMode == .panel {
            topSeparatorView.isHidden = drawer.drawerPosition == .collapsed
            bottomSeperatorView.isHidden = drawer.drawerPosition == .collapsed
        } else {
            topSeparatorView.isHidden = false
            bottomSeperatorView.isHidden = true
        }
    }
    
    // This function is called when the current drawer display mode changes. Make UI customizations here.
    func drawerDisplayModeDidChange(drawer: PulleyViewController) {
        gripperTopConstraint.isActive = drawer.currentDisplayMode == .drawer
    }
}

// MARK: - Searchbar
extension SearchDrawerVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        pulleyViewController?.setDrawerPosition(position: .open, animated: true)
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

// MARK: - Search TableView
extension SearchDrawerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let searchViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewVC")
        
        pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
        
        pulleyViewController?.setPrimaryContentViewController(controller: searchViewVC, animated: false)
    }
}

// Handle the user's selection.
extension SearchDrawerVC: GMSAutocompleteResultsViewControllerDelegate {
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

//// MARK: - CLLocationManagerDelegate
//extension SearchDrawerVC: CLLocationManagerDelegate {
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


