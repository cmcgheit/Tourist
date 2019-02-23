//
//  RecommendedPlaces.swift
//
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import GoogleMaps

class RecommendedPlaces: NSObject {
    
    public let name: String
    public let address: String
    public let location: CLLocationCoordinate2D
    public let zoom: Float
    
    init(name: String, address: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.address = address
        self.location = location
        self.zoom = zoom
    }
}






