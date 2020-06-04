//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

/*
 1.Figure out how to get API data and parse it correctly
2. grab text from the search bar, and submit a request with text as parameter
 
 3.change values of city label to search bar text and temperature label to value of temperature from API
 
 //working on
 4.check time zone in seconds and assign it a value, adjust system time to it and if past 3 pm!?(IDK) change the background
 
 //working on
 5. depending on ID value change conditionImageView Image
 
 */
class WeatherViewController: UIViewController {
    var city = ""
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var searchBar: UITextField!
    
    let data = getWeatherData()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        data.delegate = self
       
        
    }
    //added a tap gesture so if user clicks outside bar it will be resigned
    @IBAction func onTap(_ sender: Any) {
        print("tapped")
        searchBar.resignFirstResponder()
    }
    
    //when search button clicked on activates this
    @IBAction func search(_ sender: Any) {
        print("In search")
        
        let city = self.searchBar.text
        data.getWeather(city: city!)
       
        
        //print(data.getWeather(city: searchBar.text!))
        
    }
}




extension WeatherViewController: GetWeatherDataDelegate {
 func didGetWeather(StoreData: StoreData) {
        DispatchQueue.main.async {
            print("in extension!")
            self.searchBar.resignFirstResponder()
         self.temperatureLabel.text = String(StoreData.temp)
            let city = self.searchBar.text
            self.cityLabel.text = city
           print(StoreData.id)
           //let timezoneSec = StoreData.time
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
