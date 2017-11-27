//
//  FavoritePlaces.swift
//  Favorite-Places
//
//  
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import GoogleMaps

class FavoritePlaces: NSObject {
    
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.location = location
        self.zoom = zoom
    }
}
