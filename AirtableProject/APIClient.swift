//
//  APIClient.swift
//  AirtableProject
//
//  Created by Mark Koslow on 9/4/16.
//  Copyright © 2016 Mark Koslow. All rights reserved.
//

import Foundation

enum Endpoint: String {
    case Restaurants = "https://api.airtable.com/v0/appJ8AGNLk708812e/RestaurantsList?api_key=keyk2tbwEshOdGpfd"
}

class APIClient {
    
    enum Request {
        case CoordinatesForAddress(String)
        
        // Method
        var method: String {
            switch self {
            case .CoordinatesForAddress: return "GET"
            }
        }
        
        // Base URL
        var baseURL: String {
            return "https://maps.googleapis.com/maps/api/geocode/json"
        }
        
        // API Key
        var apiKey: String {
            return "AIzaSyDLbK-ESl7ihJ_SmjHqC0JmC8YXfBzRu1g"
        }
        
        /*
        // Path
        var path: String {
            switch self {
            case .CoordinatesForAddress: return "xyz"
            }
        }
         */
        
        // Parameters
        var parameters: [String: AnyObject]? {
            switch self {
            case let .CoordinatesForAddress(address):
                var params: [String: AnyObject] = [:]
                params["address"] = address.stringByReplacingOccurrencesOfString(" ", withString: "+")
                params["key"] = apiKey
                return params
            }
        }
        
        // Compose URL request using computed properties above
        func URL() -> NSURL? {
            guard let baseURL = NSURL(string: baseURL) else { print("baseURL no worky"); return nil }
            
            let urlComponents = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: false)
            if let parameters = parameters where method == "GET" {
                urlComponents?.queryItems = Array(parameters.map { (name, value) -> [NSURLQueryItem] in
                    switch value {
                    case let string as String:
                        return [NSURLQueryItem(name: name, value: string)]
                    default: fatalError("Unsupported query value: \(value)")
                    }
                    }.flatten())
            }
            
            return urlComponents?.URL
        }
    }
    
    
    static func fetchResultsForEndpoint(endpoint: Endpoint, completion: ([String : AnyObject]) -> Void) {
        guard let url = NSURL(string: endpoint.rawValue) else { fatalError("Endpoint no longer valid") }
        
        fetchResultsForURL(url, completion: completion)
    }
    
    
    static func fetchResultsForURL(url: NSURL, completion: ([String : AnyObject]) -> Void) {
        let urlRequest = NSURLRequest(URL: url)
        
        let session = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: { data, response, error in
            guard error == nil else { print("Error: \(error)"); return }
            
            guard let data = data else { print("Data from endpoint \(url) is nil"); return }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    completion(json)
                }
            } catch {
                print("Could not be parsed properly")
            }
        })
        
        session.resume()
    }
}