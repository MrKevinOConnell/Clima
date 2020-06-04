//
//  StoringData.swift
//  Clima
//
//  Created by Kevin O'Connell on 6/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
//takes some info from a couple of places on the API
struct GetData: Decodable
{   let weather: [weather]
    let main: main
    let wind: wind
    let clouds: clouds
    let timezone: Int
}
struct weather: Decodable
{
    let id: Int
    let main: String!
    let description: String!
    let icon: String!
}
struct main: Decodable
{
    let temp: Double
    let feels_like: Double!
    let temp_min: Double!
    let temp_max: Double!
    let pressure : Int
    let humidity: Int
}
struct clouds: Decodable
{
    let all: Int
}
struct wind: Decodable
{
    let speed: Double
    let deg: Int!
}

