//
//  ViewController.swift
//  David_Heremans_Multec_Werkstuk2
//
//  Created by Astrid Heremans on 18/08/18.
//  Copyright © 2018 David Heremans. All rights reserved.
//

import UIKit
import MapKit

import CoreData
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

func getData(){
    let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale")
    let urlRequest = URLRequest(url: url!)
    
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    let task = session.dataTask(with: urlRequest){
        (data, response, error) in
        guard error == nil else {
            print("error calling GET")
            print(error!)
            return
        }
        guard let responseData = data else {
            print("Error: did not receive data")
            return
        }
        do {
            guard let json = JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject]
        }
        
        for station in json! {
            let naam = station["name"] as! String
            let aantalBikeStands = station["bike_stands"] as! Int
            let aantalBikeStandsAvailable = station["available_bike_stands"] as! Int
            let aantalBikesAvailable = station["available_bikes"] as! Int
        }
    }
    task.resume()
    
}

