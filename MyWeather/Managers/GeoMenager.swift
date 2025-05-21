//
//  GeoCity.swift
//  MyWeather
//
//  Created by Роман Шульган on 18.05.2025.
//


import Foundation

class GeoManager {
    let apiKey = "30c145fddde5c096f9f184e8b525bb0c"

    func searchCities(query: String, completion: @escaping ([GeoCity]) -> Void) {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(encoded)&limit=5&appid=\(apiKey)&lang=ru") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            do {
                let cities = try JSONDecoder().decode([GeoCity].self, from: data)
                DispatchQueue.main.async {
                    completion(cities)
                }
            } catch {
                print("Geo decoding error:", error)
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}
