//
//  Item.swift
//  MyWeather
//
//  Created by Роман Шульган on 21.05.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
