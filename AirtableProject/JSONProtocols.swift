//
//  JSONHelpers.swift
//  AirtableProject
//
//  Created by Mark Koslow on 9/5/16.
//  Copyright © 2016 Mark Koslow. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    static func decode(json: [String: AnyObject]) -> Self?
}

protocol JSONArrayDecodable {
    static func decodeArray(json: [String: AnyObject]) -> [Self]?
}

extension String {
    func mapToCoordinate() -> Coordinate? {
        let parts = self.characters.split{$0 == ","}.map(String.init)
        
        if let latitude = Double(parts[0]), longitude = Double(parts[1]) {
            return Coordinate(latitude: latitude, longitude: longitude)
        }
        
        return nil
    }
}