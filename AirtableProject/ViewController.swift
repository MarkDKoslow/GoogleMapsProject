//
//  ViewController.swift
//  AirtableProject
//
//  Created by Mark Koslow on 9/4/16.
//  Copyright © 2016 Mark Koslow. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class ViewController: UIViewController {
    
    private var mapView: GMSMapView?
    private var restaurants: [Restaurant]? {
        didSet {
            reloadMap()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a GMSCameraPosition over San Francisco
        let camera = GMSCameraPosition.cameraWithLatitude(37.789745, longitude: -122.41057, zoom: 12.0)
        let mapView = GMSMapView.mapWithFrame(view.frame, camera: camera)
        mapView.myLocationEnabled = true
        view.addSubview(mapView)
        self.mapView = mapView
        
        // Fetch restaurants
        APIClient.fetchResultsForEndpoint(.Restaurants, completion: { json in
            self.restaurants = Restaurant.decodeArray(json)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMap() {
        guard let restaurants = self.restaurants else { return }
        
        for restaurant in restaurants {
            // If restaurant already has coordinates, place marker and continue
            if let location = restaurant.coordinates {
                dispatch_async(dispatch_get_main_queue(),{ [weak self] in         // Must place marker on main thread
                    self?.placeMarkerForRestaurant(restaurant, atLocation: location)
                })
                continue
            }
            
            // If restaurant has no coordinates, make sure address is present
            guard let address = restaurant.address else { print("Restaurant: \(restaurant.name) has no address and no coordinates"); return }
            
            // Request coordinates for address, place marker
            guard let requestURL = APIClient.Request.CoordinatesForAddress(address).URL() else { print("NO URL for \(restaurant)"); return }
            
            APIClient.fetchResultsForURL(requestURL, completion: { json in
                guard let location = Coordinate.decode(json) else { print("Coordinate not decoded properly"); return }
                
                dispatch_async(dispatch_get_main_queue(),{ [weak self] in
                    self?.placeMarkerForRestaurant(restaurant, atLocation: location)
                })
            })
        }
    }
    
    func placeMarkerForRestaurant(restaurant: Restaurant, atLocation location: Coordinate) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.title = restaurant.name
        marker.snippet = restaurant.cuisine
        marker.map = mapView
        marker.appearAnimation = kGMSMarkerAnimationPop
    }
}

