//
//  MockDataManager.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import Combine
import CoreLocation
import Foundation

class MockDataManager {
    var currentWeather: CurrentWeatherResponse

    init() {
        currentWeather = CurrentWeatherResponse(
            coord: Coord(lon: -74.3936, lat: 40.5236),
            weather: [
                Weather(id: 800,
                        main: "Clear",
                        description: "clear sky",
                        icon: "10d")
            ],
            base: "stations",
            main: Main(
                temp: 78.55,
                feelsLike: 78.17,
                tempMin: 70.68,
                tempMax: 83.91,
                pressure: 1015,
                humidity: 44
            ),
            visibility: 10000,
            wind: Wind(
                speed: 4,
                deg: 264
            ),
            clouds: Clouds(
                all: 0
            ),
            dt: 1684952779,
            sys: Sys(
                type: 2,
                id: 2007488,
                country: "US",
                sunrise: 1684920841,
                sunset: 1684973705
            ),
            timezone: -14400,
            id: 5097529,
            name: "Edison",
            cod: 200
        )
    }
}

extension MockDataManager: DataManagerProtocol {
    func getWeatherForLocation(location: CLLocationCoordinate2D) -> AnyPublisher<CurrentWeatherResponse, Error> {
        return Just(currentWeather)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
