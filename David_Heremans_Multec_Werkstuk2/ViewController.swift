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
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
   

    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        do{
            guard let dataStation = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyObject] else {
                print("failed serializaton")
                return
            }
            
            for station in dataStation!{
                let number = station["number"] as! Int
                let name = station["name"] as! String
                let address = station["address"] as! String
                let bike_stands = station["bike_stands"] as! Int
                let available_bike_stands = station["available_bike_stands"] as! Int
                let available_bikes = station["available_bikes"] as! Int
                let position = station["position"] as? [String: Double]
                let lat = position!["lat"]
                let lng = position!["lng"]
                let last_update = station["last_update"] as! Int
                let contract_name = station["contract_name"] as! String
                let banking = station["banking"] as! Bool
                let bonus = station["bonus"] as! Bool
                
                
            
                
                let mangedContext = self.appDelegate?.persistentContainer.viewContext
                
                let dataStation = NSEntityDescription.insertNewObject(forEntityName: "VilloStation", into: mangedContext!) as! VilloStation
                
                dataStation.number = Int16(number)
                dataStation.address = address
                dataStation.name = name
                dataStation.bike_stands = Int16(bike_stands)
                dataStation.available_bikes = Int16(available_bikes)
                dataStation.available_bike_stands = Int16(available_bike_stands)
                dataStation.lat = lat!
                dataStation.lng = lng!
                dataStation.last_update = Int64(last_update)
                dataStation.contract_name = contract_name
                dataStation.banking = banking
                dataStation.bonus = bonus
                
                do {
                    try mangedContext?.save()
                }catch{
                    fatalError("fail")
                }
                
            }
        }
    }
    task.resume()
    
    /*DispatchQueue.main.async {
        
    }*/
    
}

}

