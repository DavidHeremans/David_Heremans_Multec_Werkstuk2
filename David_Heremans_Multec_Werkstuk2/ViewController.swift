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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

