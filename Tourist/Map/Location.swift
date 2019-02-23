//Location.swift, created with love by C McGhee

import Foundation
import ObjectMapper

struct Location: Mappable {
    
    var latitude = 0.0
    var longtidude = 0.0
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        latitude    <- map["lat"]
        longtidude  <- map["lng"]
    }
    
}
