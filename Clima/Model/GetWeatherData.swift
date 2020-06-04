//
//  GetWeatherData.swift
//  Clima
//
//  Created by Kevin O'Connell on 6/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
protocol GetWeatherDataDelegate {
    func didGetWeather(StoreData: StoreData)
    func didFailWithError(_ error: Error)
}

//made a class cause I thought it would be easier to call from this file
class getWeatherData{
    var delegate: GetWeatherDataDelegate?
    //calls API
    func getWeather(city: String) {
        //full api link, in future implemention would make a query so info can be accessed easier for cities like San Francisco
        let link = "https://api.openweathermap.org/data/2.5/weather?appid=882184a28007746af6af44480279fdfd&units=metric&q="+city
        guard let url = URL(string: link) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            //data from API call
            if let finishedData = data {
                //data parsed
                if let theData = self.parseJSON(finishedData) {
                  
                    self.delegate?.didGetWeather(StoreData: theData)
                }
            }
            
            
        }.resume()
        
        
    }
    //very similar to the ByteCoin File in nature
    func parseJSON(_ data: Data) -> StoreData?
    {
        do
        {
            //collect API data here
          
            let weather = try JSONDecoder().decode(GetData.self,from: data)
            let temp = weather.main.temp
            let wind = weather.wind.speed
            let pressure = weather.main.pressure
            let clouds  = weather.clouds.all
            let id = weather.weather[0].id
            var timezone = weather.timezone
            var storeData = StoreData(temp: temp,pressure:pressure, speed:wind, clouds: clouds,id:id,timezone: timezone )
            
            return storeData
        }
            //error caught here
        catch let error
        {
            print(error)
            self.delegate?.didFailWithError(error)
            return nil
        }
        
    }
}
