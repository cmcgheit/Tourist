//Coordinate.swift, created with love by C McGhee

import Foundation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate: JSONDecodable {
    init?(json: [String : Any]) {
        guard let latitudeValue = json["latitude"] as? Double, let longitudeValue = json["longitude"] as? Double else { return nil }
        self.latitude = latitudeValue
        self.longitude = longitudeValue
    }
}
