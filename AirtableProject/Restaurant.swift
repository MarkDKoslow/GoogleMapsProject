//
//  Restaurant.swift
//  AirtableProject
//
//  Created by Mark Koslow on 9/4/16.
//  Copyright © 2016 Mark Koslow. All rights reserved.
//

import Mapper

struct Restaurant: Mappable {
    let name: String
    let cuisine: String
    let address: String?
    var coordinates: Coordinate?
    
    init(map: Mapper) throws {
        try name = map.from("Name")
        try cuisine = map.from("Notes")
        address = map.optionalFrom("Address")
        if let coordinatesString: String = map.optionalFrom("Address") {    // Used for addresses with coordinate values
            coordinates = coordinatesString.mapToCoordinate()
        }
    }
}

extension Restaurant: JSONArrayDecodable {
    static func decodeArray(json: [String: AnyObject]) -> [Restaurant]? {
        guard let records = json["records"] as? [[String: AnyObject]] else { fatalError("No records key when decoding restaurants") }
        
        var restaurants: [Restaurant] = []
        for record in records {
            if let fields = record["fields"] as? [String: String], restaurant = Restaurant.from(fields) {
                restaurants.append(restaurant)
            }
        }
        
        return restaurants
    }
}