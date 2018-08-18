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
        
        laatZienOpKaart()
        getData()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(){
    let mangedContext = self.appDelegate?.persistentContainer.viewContext

    
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
                }
                do {
                    try mangedContext?.save()
                }catch{
                    fatalError("fail")
                }
            }
        }
        task.resume()
    }
    
    func laatZienOpKaart()  {
            
            let mangedContext = self.appDelegate?.persistentContainer.viewContext

                let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "VilloStation")
                
            var opgehaaldeStations:[VilloStation] = []
            
                do{
                    opgehaaldeStations = try mangedContext?.fetch(stationFetch) as! [VilloStation]
                    
                    let stations = opgehaaldeStations
                    
                    for station in stations {
                        let annotation = MKPointAnnotation()
                        annotation.title = station.name
                        annotation.coordinate = CLLocationCoordinate2D(latitude: station.lat, longitude: station.lng)
                        self.myMapView.addAnnotation(annotation)
                        self.myMapView.selectAnnotation(annotation, animated: true)

                    }
                } catch {
                    fatalError("failed to fetch: \(error)")
                }
            
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let center = CLLocationCoordinate2D(latitude: 50.862747, longitude: 4.353424)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.myMapView.setRegion(region, animated: true)
    }
            
    }
    /*Eigen locatie, afkomstig van https://stackoverflow.com/questions/25449469/show-current-location-and-update-location-in-mkmapview-in-swift */
            
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.myMapView.setRegion(region, animated: true)
             }
             
            }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "DetailStationViewController", sender: self)
    }
   
    }
    




