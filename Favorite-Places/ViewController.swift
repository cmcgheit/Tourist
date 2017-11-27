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

enum Location {
    case startLocation
    case destinationLocation
}

class ViewController: UIViewController, GMSMapViewDelegate {
    
        var mapView: GMSMapView?
        var marker = GMSMarker()
        var rectangle = GMSPolyline()
        var userCurrentLocation = CLLocation()
        var locationStart = CLLocation()
        var locationEnd = CLLocation()
        var currentFavoritePlace: FavoritePlaces?
        
    @IBOutlet weak var pinTurnBtn: UIButton!
    @IBOutlet weak var streetViewBtn: UIButton!
    
        let places = [FavoritePlaces(name:"Favorite Place #2 - Soldier Field", location: CLLocationCoordinate2DMake(41.864833, -87.615442), zoom:16), FavoritePlaces(name:"Favorite Place #3 - Millenium Park", location: CLLocationCoordinate2DMake(41.882633, -87.622580), zoom:18), FavoritePlaces(name:"Favorite Place #4 - Navy Pier", location: CLLocationCoordinate2DMake(41.891692, -87.607388), zoom:18), FavoritePlaces(name:"Favorite Place #5 - DuSable Museum of African-American History", location: CLLocationCoordinate2DMake(41.791802, -87.607100), zoom: 18)]
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let camera = GMSCameraPosition.camera(withLatitude: 41.879092, longitude: -87.635904, zoom: 14) // Starting Map Position
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            view = mapView
            
            // MARK: - StreetView  Properties
            func loadView() {
                let panoView = GMSPanoramaView(frame: .zero)
                self.view = panoView
      
                panoView.moveNearCoordinate(CLLocationCoordinate2DMake(currentFavoritePlace?.location, <#CLLocationDegrees#>))
                panoView.animate(to: GMSPanoramaCamera(heading: 90, pitch: 0, zoom: 1), animationDuration: 2)
            }
            
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
        
        func next() {
            
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
    }

    // MARK: Turn by Turn
    func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // Polyline route
            for route in routes {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
        }
        
        // MARK: - Google Maps Actions Buttons
        @IBAction func turnByTurnBtnPressed(_ sender: UIButton) {
            self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        }
        
        @IBAction func streetViewBtnPressed(_ sender: UIButton) {
            loadView()
           
        }
  
    }


// MARK: Search Bar Extension
public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let mapTextField = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        mapTextField.textColor = color
    }
    
}


// MARK: Street View Extension
extension ViewController: GMSPanoramaViewDelegate {
    
    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print(error.localizedDescription)
    }
    
}



