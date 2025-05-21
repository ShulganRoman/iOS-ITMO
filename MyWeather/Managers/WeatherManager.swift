//
//  WeatherManager.swift
//  MyWeather
//
//  Created by Роман Шульган on 18.05.2025.
//


import Foundation

class WeatherManager {
    let apiKey = "30c145fddde5c096f9f184e8b525bb0c"
    
    func fetchWeather(for city: String, completion: @escaping (WeatherData?) -> Void) {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&appid=\(apiKey)&units=metric&lang=ru"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch {
                print("Ошибка декодирования: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func fetchForecast(for city: String, completion: @escaping ([ForecastEntry]) -> Void) {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityQuery)&appid=\(apiKey)&units=metric&lang=ru"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.list)
                }
            } catch {
                print("Ошибка прогноза:", error)
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }

}
