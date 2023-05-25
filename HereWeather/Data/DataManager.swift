//
//  DataManager.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import Combine
import CoreLocation
import SwiftUI

protocol DataManagerProtocol {
    func getWeatherForLocation(location: CLLocationCoordinate2D) -> AnyPublisher<CurrentWeatherResponse, Error>
}

class DataManager {
    static let shared: DataManagerProtocol = DataManager()
    private let remote: DataManagerProtocol = RemoteDataManager()
}

extension DataManager: DataManagerProtocol {
    func getWeatherForLocation(
        location: CLLocationCoordinate2D
    ) -> AnyPublisher<CurrentWeatherResponse, Error> {
        remote.getWeatherForLocation(location: location)
    }
}
