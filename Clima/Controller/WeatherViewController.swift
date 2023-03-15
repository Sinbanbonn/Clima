//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, UITextFieldDelegate , WeatherManagerDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tempLabale: UILabel!
    
    var locationManager = CLLocationManager()
    
    
    var weatherManager = WeatherManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        weatherManager.delegate = self
        
        searchTextField.delegate = self
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        if searchTextField.text != ""{
            weatherManager.fetchWeather(name: searchTextField.text!)
            searchTextField.text = ""
        }else{
            searchTextField.placeholder = "Write town name..."
            
        }
        
    }
    
    @IBAction func geoButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        locationManager.requestLocation()
        view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(name: city)
        }
        searchTextField.text = ""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Write town name..."
            return false
        }
    }
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel){
        DispatchQueue.main.async {
            self.tempLabale.text = String(format: "%.1f " , weather.temperature)
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.name
        }
        
        
    }
    
    
    
}
extension WeatherViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("Succes")
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon  = location.coordinate.longitude
            print(lat)
            weatherManager.fetchWeather(lot: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

