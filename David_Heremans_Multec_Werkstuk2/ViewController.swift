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

//User location code afkomstig van https://www.youtube.com/watch?v=sVMbFgUdDg0

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    

    var locationManager = CLLocationManager()

    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show user location
        myMapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted ||
            CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined {
                
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("turn on location")
        }
        getData()
        laatZienOpKaart()


        maakCoreDataLeeg()
    }
    
    /*Deze functie is afkomstig van https://stackoverflow.com/questions/5621173/xcode-mac-keyboard-shortcut-to-type-the-or-sign-double-vertical-bar */
    
    func maakCoreDataLeeg() {
        
        let mangedContext = self.appDelegate?.persistentContainer.viewContext

        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "VilloStation")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do{
            try mangedContext?.execute(request)
            try mangedContext?.save()
        } catch {
            print("ER is iets fout gegaan")
        }

    }
   
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Haalt de data uit de core data
    //Code uit de slides en de werkcolleges
    
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
    
    // Zorgt dat de annotations zichtbaar zijn op de map
    // Code uit de slides en de werkcolleges
    
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
                        
                        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
                            self.performSegue(withIdentifier: "DetailStationViewController", sender: self)
                        }

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
    
    // Show user location
            
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self.myMapView.setRegion(region, animated: true)
            }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("unable to find user location")
    }
    //Om naar volgende detailStation view te gaan
    //Code afkomstig van https://stackoverflow.com/questions/33053832/swift-perform-segue-from-map-annotation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let  reuseId = "pin"
        
        var pinView = myMapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let rightButton: AnyObject! = UIButton.init(type: UIButtonType.detailDisclosure)
            rightButton.title(for: UIControlState.normal)
            
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
        performSegue(withIdentifier: "DetailStationViewController", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailStationViewController" {
            let nextVc = segue.destination as! DetailStationViewController
            
            nextVc.Name = (sender as! MKAnnotationView).annotation!.title as! String
        }
    }
   
   
    }
    




