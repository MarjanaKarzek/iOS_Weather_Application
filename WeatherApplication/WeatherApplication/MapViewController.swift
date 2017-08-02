//
//  MapViewController.swift
//  WeatherApplication
//
//  Created by Marjana Karzek on 02/08/17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeController: UISegmentedControl!
    
    let regionRadius: CLLocationDistance = 1000
    //let locationManager = CLLocationManager()
    var location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        centerMapOnLocation(location: location)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func segmentChanged(_ sender: AnyObject){
        print(mapTypeController.selectedSegmentIndex)
        switch mapTypeController.selectedSegmentIndex{
        case 0:
            mapView.mapType = MKMapType.standard
            break
        case 1:
            mapView.mapType = MKMapType.satellite
            break
        case 2:
            mapView.mapType = MKMapType.hybrid
            break
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
