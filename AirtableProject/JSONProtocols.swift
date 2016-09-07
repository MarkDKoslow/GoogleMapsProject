//
//  JSONProtocols.swift
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