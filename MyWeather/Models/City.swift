//
//  City.swift
//  MyWeather
//
//  Created by Роман Шульган on 18.05.2025.
//


import Foundation
import SwiftData

@Model
class City {
    var name: String

    init(name: String) {
        self.name = name
    }
}
