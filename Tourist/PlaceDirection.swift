//PlaceDirection.swift, created with love by C McGhee

import Foundation
import ObjectMapper

struct PlaceDirection: Mappable {
    
    var geocodedWaypoints = [GeocodedWaypoint]()
    var routes = [Route]()
    var status = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        geocodedWaypoints <- map["geocoded_waypoints"]
        routes            <- map["routes"]
        status            <- map["status"]
    }
    
}
