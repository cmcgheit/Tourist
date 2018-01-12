//Leg.swift, created with love by C McGhee

import Foundation
import ObjectMapper

struct Leg: Mappable {
    
    var distance = GoogleMapValue()
    var duration = GoogleMapValue()
    var endAddress = ""
    var endLocation = Location()
    var startAddress = ""
    var startLocation = Location()
    var steps = [Step]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        distance           <- map["distance"]
        duration           <- map["duration"]
        endAddress         <- map["end_address"]
        endLocation        <- map["end_location"]
        startAddress       <- map["start_address"]
        startLocation      <- map["start_location"]
        steps              <- map["steps"]
    }
    
}
