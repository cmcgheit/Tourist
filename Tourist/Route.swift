//Route.swift, created with love by C McGhee

import Foundation
import ObjectMapper

struct Route: Mappable {
    
    var bounds = Bounds()
    var copyrights = ""
    var legs = [Leg]()
    var overviewPolyline = Polyline()
    var summary = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        bounds              <- map["bounds"]
        copyrights          <- map["copyrights"]
        legs                <- map["legs"]
        overviewPolyline    <- map["overview_polyline"]
        summary             <- map["summary"]
    }
    
}
