//  CityListView.swift
//  MyWeather
//
//  Created by Роман Шульган on 18.05.2025.
//


import SwiftUI
import SwiftData

struct CityListView: View {
    @Query private var cities: [City]
    @Environment(\.modelContext) private var context

    @State private var searchText: String = ""
    @State private var suggestions: [GeoCity] = []

    private let geoManager = GeoManager()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .cyan]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    searchField

                    suggestionList

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if cities.isEmpty {
                                Text("Нет добавленных городов")
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .padding(.top, 100)
                            } else {
                                ForEach(cities) { city in
                                    NavigationLink(destination: WeatherView(city: city.name)) {
                                        HStack {
                                            Text(city.name)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(12)
                                    }
                                    .contextMenu {
                                        Button("Удалить", role: .destructive) {
                                            deleteCityByName(city.name)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                .navigationTitle("Города")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    private var searchField: some View {
        TextField("Добавить город...", text: $searchText)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .foregroundColor(.white)
            .overlay(
                HStack {
                    Spacer()
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            suggestions = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 12)
                        }
                    }
                }
            )
            .onChange(of: searchText) { _ in searchCities() }
            .submitLabel(.search)
            .padding(.horizontal)
    }

    @ViewBuilder
    private var suggestionList: some View {
        if !suggestions.isEmpty {
            VStack(spacing: 8) {
                ForEach(suggestions) { suggestion in
                    Button {
                        addCity(name: suggestion.name)
                        searchText = ""
                        suggestions = []
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(suggestion.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(suggestion.state ?? ""), \(suggestion.country)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            .transition(.opacity)
            .animation(.easeInOut, value: suggestions)
        }
    }

    private func searchCities() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            suggestions = []
            return
        }

        geoManager.searchCities(query: trimmed) { results in
            withAnimation {
                self.suggestions = results
            }
        }
    }

    private func addCity(name: String) {
        if !cities.contains(where: { $0.name.lowercased() == name.lowercased() }) {
            let city = City(name: name)
            context.insert(city)
        }
    }

    private func deleteCityByName(_ name: String) {
        if let city = cities.first(where: { $0.name == name }) {
            context.delete(city)
        }
    }
}
