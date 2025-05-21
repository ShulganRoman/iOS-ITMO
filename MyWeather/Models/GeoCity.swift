//
//  GeoCity.swift
//  MyWeather
//
//  Created by Роман Шульган on 21.05.2025.
//


import Foundation

struct GeoCity: Decodable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let country: String
    let state: String?
    let lat: Double
    let lon: Double
}
