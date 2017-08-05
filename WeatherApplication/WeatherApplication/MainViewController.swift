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
    var weatherData = [WeatherCard]()
    
    let weatherReceiver = WeatherReceiver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupText(){
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            defaults = delegate.defaults
        }
        
        //display text
        if let usernameValue = defaults.string(forKey: "WeatherApp_username"){
            if(usernameValue == ""){
                welcomeTextLabel.text = "Wellcome, "
            }else{
                welcomeTextLabel.text = "Hello \(usernameValue), "
            }
        }else {
            welcomeTextLabel.text = "Wellcome, "
        }
        let previewAmountValue = defaults.integer(forKey: "WeatherApp_previewAmount")
        if previewAmountValue != 0 {
            selectedPreviewAmount = previewAmountValue
        }
        weatherExplanationLabel.text = "This is the weather for the next \(selectedPreviewAmount) days: "
        
        //display date
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        currentDateLabel.text = "\(day)-\(month)-\(year)"
        
        //get location
        let selectedLatitude = defaults.double(forKey: "WeatherApp_selectedLatitude")
        let selectedLongitude = defaults.double(forKey: "WeatherApp_selectedLongitude")
        if(selectedLatitude != 0 && selectedLongitude != 0){
            location = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
            print("\(selectedLatitude) \(selectedLongitude)")
            setButtonTextToCity()
        }else{
            print("no selected location")
            determineCurrentLocation()
        }
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
        return weatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as! WeatherCollectionViewCell
        // Configure the cell
        
        let weatherid = weatherData[indexPath.row].weather.id
        cell.weatherImage.image = UIImage(named: weatherReceiver.getWeatherIcon(id: weatherid))
        cell.weatherTemperature.text = weatherData[indexPath.row].temperature
        cell.weatherDate.text = weatherData[indexPath.row].date
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let speechUtterance = AVSpeechUtterance(string: weatherData[indexPath.row].text)
        speechSynthesizer.speak(speechUtterance)
    }
    
    @IBAction func facbookButtonPushed(sender: UIButton){
        let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        var initalText = "This is the weather for the next \(selectedPreviewAmount) days: "
        for card in weatherData{
            initalText.append("\n\(card.summaryText)")
        }
        facebookSheet.setInitialText(initalText)
        for card in weatherData{
            let image = weatherReceiver.getWeatherIcon(id: card.weather.id)
            facebookSheet.add(UIImage(named: image))
        }
        self.present(facebookSheet, animated:true, completion:nil)
    }
    
    @IBAction func twitterButtonPushed(sender: UIButton) {
        let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let initalText = "This is the weather for the next \(selectedPreviewAmount) days "
        // no summary text because twitter only provides 160 chars
        twitterSheet.setInitialText(initalText)
        for card in weatherData{
            let image = weatherReceiver.getWeatherIcon(id: card.weather.id)
            twitterSheet.add(UIImage(named: image))
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
        setButtonTextToCity()
    }
    
    func setButtonTextToCity(){
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            //print("\(self.location.coordinate.latitude) \(self.location.coordinate.longitude)")
            if let city = placeMark.addressDictionary!["City"] as? String {
                //print(city)
                self.currentLocationLabel.setTitle(city, for: UIControlState.normal)
            }else {
                let homelocationValue = self.defaults.string(forKey: "WeatherApp_homelocation")
                if homelocationValue != "" {
                    self.currentLocationLabel.setTitle(homelocationValue, for: UIControlState.normal)
                }else{
                    self.currentLocationLabel.setTitle("London", for: UIControlState.normal)
                    self.location = CLLocation(latitude: 51.50998,longitude: -0.1337)
                }
            }
            DispatchQueue.main.async(execute: { self.collectionView.reloadData() })
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        setupText()
        
        //get weather information
        weatherReceiver.callWeatherdata(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, forecast: selectedPreviewAmount){
            () in
            self.weatherReceiver.extractData(){
                ()
                self.weatherData = self.weatherReceiver.weatherCards
                print("data completed \(self.weatherData.count) data objects received")
                print("for location \(self.location.coordinate.latitude) \(self.location.coordinate.longitude)")
                //dispatch reload call to main thread
                DispatchQueue.main.async(execute: { self.collectionView.reloadData() })
            }
        }
    }

    @IBAction func reloadLocation(sender: UIButton){
        currentLocationLabel.setTitle("loading...", for: UIControlState.normal)
        defaults.set(0, forKey: "WeatherApp_selectedLatitude")
        defaults.set(0, forKey: "WeatherApp_selectedLongitude")
        determineCurrentLocation()
        getWeatherInformation()
    }
    
    func getWeatherInformation(){
        weatherReceiver.callWeatherdata(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, forecast: selectedPreviewAmount){
            () in
            self.weatherReceiver.extractData(){
                ()
                self.weatherData = self.weatherReceiver.weatherCards
                print("data completed \(self.weatherData.count) data objects received")
                print("for location \(self.location.coordinate.latitude) \(self.location.coordinate.longitude)")
                //dispatch reload call to main thread
                DispatchQueue.main.async(execute: { self.collectionView.reloadData() })
            }
        }
    }
}
