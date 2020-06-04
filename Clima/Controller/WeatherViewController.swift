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
        data.getWeather(city: "London")
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
           
       
      /*
    this might be organized,but I wanted to keep it async and i didn't know a better way to make it so.
            */
       print("System Timezone")
            let calendar = Calendar.current
            //users timezone
            var offset = calendar.timeZone.secondsFromGMT()
            print(offset)
            let date = Date()
            let secondsSince1970 =  date.timeIntervalSince1970
            //city entered timezone
            let cityTimeZone = StoreData.timezone
            print(StoreData.timezone)
            var time = 0
           //calculate the timezone of user city minus the city entered to get correct timezone in seconds
             time = offset - cityTimeZone
            if(time>0)
            {
            offset = offset - time
            }
            else
            {
                offset = offset + time
            }
            
            
            
          //calculates the current date
        let timezoneEpochOffset = (secondsSince1970 + Double(offset))
          
       //makes a date so we can mess with the data
        let finalDate = Date(timeIntervalSince1970: timezoneEpochOffset)
            print(finalDate)
            //organization
            let components = calendar
            let hour = Calendar.Component.hour
            let minute = Calendar.Component.minute
            let second = Calendar.Component.second
            let finalCalender = components.dateComponents([hour,minute,second],from: finalDate)
            
           //For whatever reason the hour is off 4 hours so I just add 4
            var correctHour = finalCalender.hour!+4
            if(correctHour>=24)
            {
                correctHour -= 24
            }
            print(correctHour)
            print(finalCalender.minute!)
            print(finalCalender.second!)
            let image1 = "light_background.pdf"
            let uiImage1 = UIImage(named: image1)
            if(correctHour >= 5 && correctHour <= 18)
            {
                let imageName = "dark_background.pdf"
                let image = UIImage(named: imageName)
                self.background.image = image
            }
            else
            {
               
                self.background.image = uiImage1
            }
           
          
          
            
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
