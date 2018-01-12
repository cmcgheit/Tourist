//GeocodedWaypoint.swift, created with love by C McGhee

import Foundation
import ObjectMapper

struct GeocodedWaypoint: Mappable {
    
    var geocoderStatus = ""
    var placeId = ""
    var types = [String]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        geocoderStatus <- map["geocoder_status"]
        placeId        <- map["place_id"]
        types          <- map["types"]
    }
    
}
