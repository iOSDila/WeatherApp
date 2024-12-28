//
//  ContentView.swift
//  WeatherApp
//
//  Created by Pubudu Dilshan on 2024-12-29.
//

import SwiftUI

struct WeatherView: View {
    @State private var cityName: String = ""
    @State private var weather: WeatherData?
    @State private var showWeatherDetails: Bool = false

    var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all) // Background gradient

                VStack(spacing: 20) {
                    Text("🌤 Weather App")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    TextField("Enter City Name", text: $cityName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)

                    Button(action: {
                        fetchWeather(city: cityName)
                    }) {
                        Text("Get Weather")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                                                       startPoint: .leading,
                                                       endPoint: .trailing))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 20)

                    if let weather = weather {
                        VStack(spacing: 10) {
                            Text("City: \(weather.name)")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)

                            Text("Temperature: \(weather.main.temp, specifier: "%.1f")°C")
                                .font(.title3)
                                .foregroundColor(.white)

                            Text("Condition: \(weather.weather.first?.description.capitalized ?? "")")
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                        .offset(y: showWeatherDetails ? 0 : 300) // Slide-in effect
                        .scaleEffect(showWeatherDetails ? 1 : 0.8) // Scale effect
                        .opacity(showWeatherDetails ? 1 : 0) // Fade-in effect
                        .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.3), value: showWeatherDetails) // Spring animation
                    }

                    Spacer()
                }
                .padding()
            }
        }

    func fetchWeather(city: String) {
        guard !city.isEmpty else { return }
        let apiKey = "de262a91eb7bed5735dc1a42cb5a63e9"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weather = decodedData
                    self.showWeatherDetails = true†
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [WeatherCondition]
}

struct Main: Codable {
    let temp: Double
}

struct WeatherCondition: Codable {
    let description: String
}

