//
//  LocationDataManager.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import Combine
import CoreLocation
import Foundation

protocol LocationDataManagerProtocol {
    var userLocation: CurrentValueSubject<CLLocation?, Never> { get }
    var authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never> { get }
    var heading: CurrentValueSubject<CLHeading?, Never> { get }
    func requestAuthorization()
    func startUpdatingLocation()
}

class LocationDataManager: NSObject, LocationDataManagerProtocol {
    private let locationManager: CLLocationManager

    let userLocation = CurrentValueSubject<CLLocation?, Never>(nil)
    let heading = CurrentValueSubject<CLHeading?, Never>(nil)
    let authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never>
    let accuracyAuthorization: CurrentValueSubject<CLAccuracyAuthorization, Never>

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager

        self.authorizationStatus = CurrentValueSubject(locationManager.authorizationStatus)
        self.accuracyAuthorization = CurrentValueSubject(locationManager.accuracyAuthorization)

        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestAuthorization() {
//      Only ask authorization if it was never asked before
        guard authorizationStatus.value == .notDetermined else { return }
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        print("Location Manager: Start Updating location")
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
}

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.accuracyAuthorization != accuracyAuthorization.value {
            accuracyAuthorization.value = manager.accuracyAuthorization
        }

        if manager.authorizationStatus != authorizationStatus.value {
            authorizationStatus.value = manager.authorizationStatus
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("got new last location: \(String(describing: locations.last))")
        userLocation.value = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading.value = newHeading
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
}
