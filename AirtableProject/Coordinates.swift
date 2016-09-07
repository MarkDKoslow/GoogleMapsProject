//
//  Coordinates.swift
//  AirtableProject
//
//  Created by Mark Koslow on 9/4/16.
//  Copyright © 2016 Mark Koslow. All rights reserved.
//

import Foundation
import Mapper

struct Coordinate: Mappable {
    let latitude: Double
    let longitude: Double
    
    init(map: Mapper) throws {
        try latitude = map.from("lat")
        try longitude = map.from("lng")
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Coordinate: JSONDecodable {
    static func decode(json: [String: AnyObject]) -> Coordinate? {
        guard let results = json["results"] as? [[String: AnyObject]] else { fatalError("No 'records' key when decoding Coordinates") }
        
        for result in results {
            if let fields = result["geometry"] as? [String: AnyObject],
                location = fields["location"] as? [String: Double],
                coordinate = Coordinate.from(location) {
                    return coordinate
                }
        }
        
        return nil
    }
}

