//
//  WeatherData.swift
//  MyWeather
//
//  Created by Роман Шульган on 18.05.2025.
//


import Foundation

struct WeatherData: Decodable, Equatable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let sys: Sys
}

struct Main: Decodable, Equatable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Decodable, Equatable {
    let description: String
    let icon: String
}

struct Wind: Decodable, Equatable {
    let speed: Double
    let deg: Int
}

struct Sys: Decodable, Equatable {
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}
