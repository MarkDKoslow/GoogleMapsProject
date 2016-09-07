//
//  String+Extensions.swift
//  AirtableProject
//
//  Created by Mark Koslow on 9/7/16.
//  Copyright © 2016 Mark Koslow. All rights reserved.
//

import Foundation

extension String {
    func mapToCoordinate() -> Coordinate? {
        let parts = self.characters.split{$0 == ","}.map(String.init)
        
        if let latitude = Double(parts[0]), longitude = Double(parts[1]) {
            return Coordinate(latitude: latitude, longitude: longitude)
        }
        
        return nil
    }
}