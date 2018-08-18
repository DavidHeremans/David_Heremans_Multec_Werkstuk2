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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
