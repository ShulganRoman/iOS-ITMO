//
//  WeatherView.swift
//  MyWeather
//
//  Created by Роман Шульган on 18.05.2025.
//


import SwiftUI

struct WeatherView: View {
    let city: String

    @State private var weather: WeatherData?
    @State private var forecast: [ForecastEntry] = []

    private let manager = WeatherManager()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .cyan]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text(city)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 2)

                    if let weather = weather {
                        currentWeatherView(for: weather)
                    } else {
                        ProgressView("Загрузка...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                    }

                    if !forecast.isEmpty {
                        Text("Прогноз")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.top, 10)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(forecast.prefix(8)) { entry in
                                    VStack(spacing: 8) {
                                        Text(hourFormatter.string(from: entry.date))
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))

                                        if let icon = entry.weather.first?.icon {
                                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                                                image.resizable()
                                            } placeholder: {
                                                Color.clear
                                            }
                                            .frame(width: 40, height: 40)
                                        }

                                        Text("\(Int(entry.main.temp))°")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            manager.fetchWeather(for: city) { data in
                withAnimation {
                    self.weather = data
                }
            }
            manager.fetchForecast(for: city) { data in
                self.forecast = data
            }
        }
    }

    private func currentWeatherView(for weather: WeatherData) -> some View {
        VStack(spacing: 16) {
            if let icon = weather.weather.first?.icon {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }

            Text("\(Int(weather.main.temp))°C")
                .font(.system(size: 64, weight: .semibold))
                .foregroundColor(.white)

            Text(weather.weather.first?.description.capitalized ?? "")
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))

            Divider().background(Color.white.opacity(0.4))

            VStack(spacing: 8) {
                weatherRow(title: "Ощущается как", value: "\(Int(weather.main.feels_like))°C")
                weatherRow(title: "Мин/Макс", value: "\(Int(weather.main.temp_min))° / \(Int(weather.main.temp_max))°")
                weatherRow(title: "Давление", value: "\(weather.main.pressure) гПа")
                weatherRow(title: "Влажность", value: "\(weather.main.humidity)%")
                weatherRow(title: "Ветер", value: "\(Int(weather.wind.speed)) м/с, \(weather.wind.deg)°")
                weatherRow(title: "Страна", value: weather.sys.country)
                weatherRow(title: "Восход", value: formatTime(weather.sys.sunrise))
                weatherRow(title: "Закат", value: formatTime(weather.sys.sunset))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 4)
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: weather)
    }

    private func weatherRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
        .font(.subheadline)
    }

    private func formatTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }

    private var hourFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}
