//
//  DetailStationViewController.swift
//  David_Heremans_Multec_Werkstuk2
//
//  Created by Astrid Heremans on 18/08/18.
//  Copyright © 2018 David Heremans. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class DetailStationViewController: UIViewController {

    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var bike_stands: UILabel!
    
    @IBOutlet weak var available_bike_stands: UILabel!
    
    @IBOutlet weak var available_bikes: UILabel!
    
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var locationManager = CLLocationManager()
    
    var Name = ""
    
    var opgehaaldeStations:[VilloStation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //gegevens uilezen van coredata
        let villoStationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "VilloStation")
        do{
            
            self.opgehaaldeStations = try self.managedContext?.fetch(villoStationFetch) as! [VilloStation]
            //print(self.opgehaaldeVilloStations[6].naam!)
            
            let stations = self.opgehaaldeStations
            
            for  station in stations {
                if (station.name == Name ){
                    
                    self.number.text = "\((station.number))"
                    
                    self.name.text = station.name
                    
                    self.address.text = station.address
                    
                    self.bike_stands.text = "\((station.bike_stands))"
                    
                    self.available_bikes.text = "\((station.available_bikes))"
                    
                    self.available_bike_stands.text = "\((station.available_bike_stands))"
                                    }
                
            }
        } catch{fatalError("Failedtofetchemployees: \(error)")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
