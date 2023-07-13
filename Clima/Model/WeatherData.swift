//
//  WeatherData.swift
//  Clima
//
//  Created by Yogalakshmi Balasubramaniam on 5/30/23.
//  

import Foundation
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
}
struct Weather: Decodable {
    let id: Int
    let description: String
    
}
