//
//  MyWeatherApp.swift
//  MyWeather
//
//  Created by Роман Шульган on 18.05.2025.
//


import SwiftUI
import SwiftData

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            CityListView()
        }
        .modelContainer(for: City.self)
    }
}
