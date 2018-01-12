//Polyline.swift, created with love by C McGhee

import Foundation
import ObjectMapper

struct Polyline: Mappable {
    
    var points = ""
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        points  <- map["points"]
    }

}

