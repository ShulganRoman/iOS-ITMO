//
//  ForecastResponse.swift
//  MyWeather
//
//  Created by Роман Шульган on 18.05.2025.
//


import Foundation

struct ForecastResponse: Decodable {
    let list: [ForecastEntry]
}

struct ForecastEntry: Decodable, Identifiable {
    var id: UUID { UUID() }

    let dt: TimeInterval
    let main: Main
    let weather: [Weather]

    var date: Date {
        Date(timeIntervalSince1970: dt)
    }
}
