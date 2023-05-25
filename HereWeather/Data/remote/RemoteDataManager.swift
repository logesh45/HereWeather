//
//  RemoteDataManager.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import CoreLocation
import Combine

class RemoteDataManager {}

extension RemoteDataManager: DataManagerProtocol {
    func getWeatherForLocation(location: CLLocationCoordinate2D) -> AnyPublisher<CurrentWeatherResponse, Error> {
        OpenWeatherAPI.instance.getWeatherForLocation(location: location)
    }
}
