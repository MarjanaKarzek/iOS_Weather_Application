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

class MapViewController: UIViewController, UISearchBarDelegate{
    
    var defaults = UserDefaults()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeController: UISegmentedControl!
    
    let regionRadius: CLLocationDistance = 1000
    var location = CLLocation()
    var lastSetLocation = CLLocation()
    var homelocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            defaults = delegate.defaults
        }
        centerMapOnLocation(location: location)
        homelocation = defaults.string(forKey: "WeatherApp_homelocation") ?? ""
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
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignore user interaction
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //set up search view
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //create search request
        let searchRequest = MKLocalSearchRequest()
        var query = searchBar.text?.lowercased()
        if(query == "home"){
            if (homelocation != ""){
                query = homelocation
                print("query: \(query ?? "nothing searching")")
            }
            else{
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.showToast(message: "no results found")
                return
            }
        }
        searchRequest.naturalLanguageQuery = query
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if let result = response{
                //remove annotation
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //get data
                let latitude = result.boundingRegion.center.latitude
                let longitude = result.boundingRegion.center.longitude
                
                self.lastSetLocation = CLLocation(latitude: result.boundingRegion.center.latitude, longitude: result.boundingRegion.center.longitude)
                
                //create new annotation based on fetched data
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                self.mapView.addAnnotation(annotation)
                
                self.centerMapOnLocation(location: CLLocation(latitude: latitude, longitude: longitude))
            }else {
                self.showToast(message: "no results found")
            }
        }
    }
    
    @IBAction func setAsLocation(_ sender: Any) {
        let annotations = self.mapView.annotations
        print(annotations)
        if annotations.count < 1 {
            showToast(message: "no location chosen")
        } else if annotations.count > 1{
            defaults.set(lastSetLocation.coordinate.latitude, forKey: "WeatherApp_selectedLatitude")
            defaults.set(lastSetLocation.coordinate.longitude, forKey: "WeatherApp_selectedLongitude")
            showToast(message: "location selected")
        } else {
            defaults.set(annotations[0].coordinate.latitude, forKey: "WeatherApp_selectedLatitude")
            defaults.set(annotations[0].coordinate.longitude, forKey: "WeatherApp_selectedLongitude")
            showToast(message: "location selected")
        }
    }
    
    func showToast(message: String) {
        let toast = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toast.textColor = UIColor.white
        toast.textAlignment = .center;
        toast.text = message
        toast.alpha = 1.0
        toast.layer.cornerRadius = 10;
        toast.clipsToBounds  =  true
        self.view.addSubview(toast)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toast.alpha = 0.0
        }, completion: {(isCompleted) in
            toast.removeFromSuperview()
        })
    }
}
