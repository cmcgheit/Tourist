//GoogleMapValue.swift, created with love by C McGhee

import Foundation
import ObjectMapper

struct GoogleMapValue: Mappable {
    
    var text = ""
    var value: Int?
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        text    <- map["text"]
        value   <- map["value"]
    }
    
}
