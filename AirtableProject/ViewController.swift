//
//  ViewController.swift
//  AirtableProject
//
//  Created by Mark Koslow on 9/4/16.
//  Copyright © 2016 Mark Koslow. All rights reserved.
//

import UIKit
import Cartography
import GooglePlaces
import GoogleMaps

class ViewController: UIViewController {
    
    private var mapView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.mapWithFrame(view.frame, camera: camera)
        mapView.myLocationEnabled = true
        view.addSubview(mapView)
        self.mapView = mapView
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        let url = NSURL(string: "https://api.airtable.com/v0/appJ8AGNLk708812e/RestaurantsList?api_key=keyk2tbwEshOdGpfd")
        let session = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { data, response, error in
            guard error == nil else { print(error); return }
            
            if let data = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print("Printing JSON")
                    print(json)
                } catch {
                    print("Could not be parsed properly")
                }
            }
        })
        
        session.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

