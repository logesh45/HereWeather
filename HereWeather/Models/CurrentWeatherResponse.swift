//
//  CurrentWeatherResponse.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import Foundation

// MARK: - CurrentWeatherResponse
struct CurrentWeatherResponse: Codable {
    var coord: Coord
    var weather: [Weather]
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var dt: Int
    var sys: Sys
    var timezone, id: Int
    var name: String
    var cod: Int
}

extension CurrentWeatherResponse {
    init(data: Data) throws {
        self = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
    }
    
    init(json: String, using encoding: String.Encoding = .utf8) throws {
            guard let data = json.data(using: encoding) else {
                throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
            }
            try self.init(data: data)
        }
}

// MARK: - Clouds
struct Clouds: Codable {
    var all: Int
}

// MARK: - Coord
struct Coord: Codable {
    var lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    var temp, feelsLike, tempMin, tempMax: Double
    var pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    var type, id: Int
    var country: String
    var sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    var id: Int
    var main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    var speed: Double
    var deg: Int
}
