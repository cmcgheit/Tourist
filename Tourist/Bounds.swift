//Bounds.swift, created with love by C McGhee

import Foundation
import ObjectMapper

struct Bounds: Mappable {
    
    var northeast = Location()
    var southwest = Location()
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        northeast   <- map["northeast"]
        southwest   <- map["southwest"]
    }
    
}
