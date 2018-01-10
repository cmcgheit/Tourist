//
//  ViewController.swift
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

class ViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pinTurnBtn: UIButton!
    @IBOutlet weak var streetViewBtn: UIButton!
    @IBOutlet weak var getUserLocationBtn: UIButton!
    @IBOutlet weak var stlLocationBtn: UIButton!
    
    var marker = GMSMarker()
    var rectangle = GMSPolyline()
    
    // Location Manager properties
    weak var locationManagerDelegate: LocationManagerDelegate?
    
    // Favorite Places properties
    var currentFavoritePlace: FavoritePlaces?
    var coordinate: CLLocationCoordinate2D?
    
    let places = [FavoritePlaces(name:"Favorite Place #2 - Soldier Field", location: CLLocationCoordinate2DMake(41.864833, -87.615442), zoom:16), FavoritePlaces(name:"Favorite Place #3 - Millenium Park", location: CLLocationCoordinate2DMake(41.882633, -87.622580), zoom:18), FavoritePlaces(name:"Favorite Place #4 - Navy Pier", location: CLLocationCoordinate2DMake(41.891692, -87.607388), zoom:18), FavoritePlaces(name:"Favorite Place #5 - DuSable Museum of African-American History", location: CLLocationCoordinate2DMake(41.791802, -87.607100), zoom: 18)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Google Map View Properties
        let camera = GMSCameraPosition.camera(withLatitude: 41.879092, longitude: -87.635904, zoom: 14) // Starting Map Position
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        self.mapView?.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.zoomGestures = true
        
        // MARK: - Favorite Places Markers
        let place_marker = GMSMarker()
        place_marker.position = CLLocationCoordinate2DMake(41.864833, -87.615442)
        place_marker.icon = GMSMarker.markerImage(with: .black)
        place_marker.appearAnimation = GMSMarkerAnimation.pop
        place_marker.title = "Favorite Place #2 - Soldier Field"
        place_marker.snippet = "Lakeside home to the Chicago Bears, this 1924 open-air stadium received a modern upgrade in 2003"
        place_marker.map = mapView
        
        let place_marker2 = GMSMarker()
        place_marker2.position = CLLocationCoordinate2DMake(41.882633, -87.622580)
        place_marker2.icon = GMSMarker.markerImage(with: .black)
        place_marker2.appearAnimation = GMSMarkerAnimation.pop
        place_marker2.title = "Favorite Place #3 - Millenium Park"
        place_marker2.snippet = "24.5-acre green space with a video display, the reflective \"Bean\" sculpture & an outdoor theater"
        place_marker2.map = mapView
        
        let place_marker3 = GMSMarker()
        place_marker3.position = CLLocationCoordinate2DMake(41.891692, -87.607388)
        place_marker3.icon = GMSMarker.markerImage(with: .black)
        place_marker3.appearAnimation = GMSMarkerAnimation.pop
        place_marker3.title = "Favorite Place #4 - Navy Pier"
        place_marker3.snippet = "Former Navy training center draws crowds with carnival rides, restaurants, shops & fireworks"
        place_marker3.map = mapView
        
        let place_marker4 = GMSMarker()
        place_marker4.position = CLLocationCoordinate2DMake(41.791802, -87.607100)
        place_marker4.icon = GMSMarker.markerImage(with: .black)
        place_marker4.appearAnimation = GMSMarkerAnimation.pop
        place_marker4.title = "Favorite Place #5 - DuSable Museum of African-American History"
        place_marker4.snippet = "Museum housing exhibits & artifacts that highlight African-American history, culture & art"
        place_marker4.map = mapView
        
        let currentLocation = CLLocationCoordinate2DMake(41.879092, -87.635904)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Favorite Place #1 - Willis Tower"
        marker.snippet = "110-story skyscraper featuring expansive views of Chicago from its 103rd-story Skydeck"
        marker.tracksInfoWindowChanges = true
        marker.icon = GMSMarker.markerImage(with: .black)
        
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        mapView?.selectedMarker = marker
        
        navigationItem.title = "Cool Places to Visit"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(ViewController.next as (ViewController) -> () -> ()))
    }
    
    @objc func next() {
        
        if currentFavoritePlace == nil {
            currentFavoritePlace = places.first
        } else {
            if let index = places.index(of: currentFavoritePlace!) {
                currentFavoritePlace = places[index + 1]
                
            }
        }
        setMapCamera()
    }
    
    private  func setMapCamera() {
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: currentFavoritePlace!.location, zoom: currentFavoritePlace!.zoom))
        CATransaction.commit()
        
        let marker = GMSMarker(position: currentFavoritePlace!.location)
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.title = currentFavoritePlace?.name
        marker.map = mapView
        mapView?.selectedMarker = marker
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
        
    }
    
    // MARK: - STL Location Button Action
    @IBAction func startSTLLocationRequestBtnPressed(_ sender: UIButton) {
        
    }
}
    
  
// MARK: Search Bar Extension (for Google Auto Complete)
public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let mapTextField = (svs.filter { $0 is UITextField }).first as? UITextField else { return } // Call from favorite markers?
        mapTextField.textColor = color
        }

}
// MARK: Street View Extension
extension ViewController: GMSPanoramaViewDelegate {
    
    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print(error.localizedDescription)
    }
    
}



