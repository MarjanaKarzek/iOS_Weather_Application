//
//  MainViewController.swift
//  WeatherApplication
//
//  Created by Marjana Karzek on 02/08/17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import UIKit
import Social
import AVFoundation
import CoreLocation

private let reuseIdentifier = "weatherCell"
private var testimages = ["testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg","testimage.jpg"]
private var testlabels = ["12-15","13-16","12-15","13-16","12-15","13-16","12-15","13-16","12-15","13-16"]
private var testdates = ["02.08.2017","02.08.2017","02.08.2017","02.08.2017","02.08.2017","02.08.2017","02.08.2017","02.08.2017","02.08.2017","02.08.2017"]
private var testtexts = ["I am reading to you","I am reading to you","I am reading to you","I am reading to you","I am reading to you","I am reading to you","I am reading to you","I am reading to you","I am reading to you","I am reading to you"]

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UIButton!
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var weatherExplanationLabel: UILabel!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var defaults = UserDefaults()
    let locationManager = CLLocationManager()
    var location = CLLocation()
    let geoCoder = CLGeocoder()
    
    var selectedPreviewAmount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupText()

    }

    func setupText(){
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            defaults = delegate.defaults
        }
        if let usernameValue:String = defaults.string(forKey: "WeatherApp_username") {
            welcomeTextLabel.text = "Hello " + usernameValue + ", "
        }else{
            welcomeTextLabel.text = "Wellcome, "
        }
        if let previewAmountValue:String = defaults.string(forKey: "WeatherApp_previewAmount") {
            weatherExplanationLabel.text = "This is the weather for the next " + previewAmountValue + " days: "
            selectedPreviewAmount = Int(selectedPreviewAmount)
        }else{
            weatherExplanationLabel.text = "This is the weather for the next 10 days: "
        }
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        currentDateLabel.text = "\(year)-\(month)-\(day)"
        
        determineCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMapView"{
            let controller = segue.destination as! MapViewController
            controller.location = location
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testimages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as! WeatherCollectionViewCell
        // Configure the cell
        cell.weatherImage.image = UIImage(named: testimages[indexPath.row])
        cell.weatherTemperature.text = testlabels[indexPath.row]
        cell.weatherDate.text = testdates[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let speechUtterance = AVSpeechUtterance(string: testtexts[indexPath.row])
        speechSynthesizer.speak(speechUtterance)
    }
    
    @IBAction func facbookButtonPushed(sender: UIButton){
        let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookSheet.setInitialText("This is the weather for the next 10 days")
        for imagetitle in testimages{
            facebookSheet.add(UIImage(named: imagetitle))
        }
        self.present(facebookSheet, animated:true, completion:nil)
    }
    
    @IBAction func twitterButtonPushed(sender: UIButton) {
        let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterSheet.setInitialText("This is the weather for the next 10 days")
        for imagetitle in testimages{
            twitterSheet.add(UIImage(named: imagetitle))
        }
        self.present(twitterSheet, animated: true, completion: nil)
    }
    
    func determineCurrentLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            //print("\(self.location.coordinate.latitude) \(self.location.coordinate.longitude)")
            if let city = placeMark.addressDictionary!["City"] as? String {
                //print(city)
                self.currentLocationLabel.setTitle(city, for: UIControlState.normal)
            }else if let homelocationValue:String = self.defaults.string(forKey: "WeatherApp_homelocation") {
                self.currentLocationLabel.setTitle(homelocationValue, for: UIControlState.normal)
                if(homelocationValue == ""){
                    self.currentLocationLabel.setTitle("London", for: UIControlState.normal)
                    self.location = CLLocation(latitude: 51.50998,longitude: -0.1337)
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
