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
 
 
 4.check time zone in seconds and assign it a value, adjust system time to it and if past 3 pm!?(IDK) change the background
 
 //working on
 5. depending on ID value change conditionImageView Image
 
 */
class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var searchBar: UITextField!

    
    let data = getWeatherData()
    override func viewDidLoad() {
        searchBar.text = "London"
        data.getWeather(city: "London")
        super.viewDidLoad()
        data.delegate = self
       
        
        // Do any additional setup after loading the view.
        
    }
    //added a tap gesture so if user clicks outside bar it will be resigned
    @IBAction func onTap(_ sender: Any) {
        
        searchBar.resignFirstResponder()
    }
    //when search button clicked on activates this
    @IBAction func search(_ sender: Any) {
        
        let city = self.searchBar.text
        data.getWeather(city: city!)
    }
}


//So we can get StoreData data
extension WeatherViewController: GetWeatherDataDelegate {
    func didGetWeather(StoreData: StoreData)
    {
        DispatchQueue.main.async {
            //takes keyboard away, changes text of the labels
            self.searchBar.resignFirstResponder()
            self.temperatureLabel.text = String(StoreData.temp)
            let city = self.searchBar.text
            self.cityLabel.text = city
            //function that runs the switch statement in the README and returns the string
            func getid(StoreData: StoreData) -> String
            {
                let id = StoreData.id
                switch  id {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud.bolt"
                default:
                    return "cloud"
                }
            }
            let a = getid(StoreData: StoreData)
            //changes conditionImageView's image based on what the output of a is
            self.conditionImageView.image = UIImage(systemName: getid(StoreData: StoreData))
            
            /*
             this might not be organized,but I wanted to keep it async and i didn't know a better way to make it so.
             
             Basically I:
             got the user date and timezone
             got the city timezone
             make them equal to each other
             
             */
            let calendar = Calendar.current
            //users timezone
            var offset = calendar.timeZone.secondsFromGMT()
            
            let date = Date()
            let secondsSince1970 =  date.timeIntervalSince1970
            //City entered timezone
            let cityTimeZone = StoreData.timezone
            
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
            //gets the correct date in seconds
            let finalOffset = (secondsSince1970 + Double(offset))
            //makes a date so we can mess with the data
            let finalDate = Date(timeIntervalSince1970: finalOffset)
            //organization of date (hour minute second)
            let components = calendar
            let hour = Calendar.Component.hour
            let minute = Calendar.Component.minute
            let second = Calendar.Component.second
            let finalCalender = components.dateComponents([hour,minute,second],from: finalDate)
            //For whatever reason the hour is off by 4 so I just add 4
            var correctHour = finalCalender.hour!+4
            //resets the hour if over 24
            if(correctHour>=24)
            {
                correctHour -= 24
            }
            //images given
            let darkImage = "dark_background.pdf"
            let darkUiImage = UIImage(named: darkImage)
            let lightImage = "light_background.pdf"
            let lightUiImage = UIImage(named: lightImage)
            //if between 5 am and 6 pm display the dark image (personally I think it represents day)
            if(correctHour >= 5 && correctHour <= 18)
            {
                self.background.image = darkUiImage
            }
            else
            {
                self.background.image = lightUiImage
            }
        }
    }
    //if there is an error entered here in console
    func didFailWithError(_ error: Error)
    {
        //For a later implementation I would make a alert here and display if no city found
        print(error)
    }
}
