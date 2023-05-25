//
//  HomeViewModel.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import Combine
import CoreLocation
import MapKit
import SwiftUI

protocol HomeViewModelProtocol {
    func getCurrentLocationWeather()
}

final class HomeViewModel: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    @Published var searchText = ""
    @Published var completionItems: [MKLocalSearchCompletion] = []

    @Published var shouldFetchLocalWeather: Bool = true
    @Published var currentWeather: CurrentWeatherResponse? = nil
    @Published var searchLocation: CLLocationCoordinate2D? = nil

    @Published var restoredLastSearch: Bool = false

    private let dataManager: DataManagerProtocol
    private var locationDataManager: LocationDataManager

    let completer = MKLocalSearchCompleter()

    private var appEnv: AppEnvironment?

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?

    private var cancellables = Set<AnyCancellable>()

    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
        let manager = CLLocationManager()
        self.locationDataManager = LocationDataManager(locationManager: manager)
        super.init()
        completer.delegate = self
    }

    private func setupLocationManager() {
        locationDataManager.authorizationStatus.assign(to: &$authorizationStatus)
        locationDataManager.userLocation.assign(to: &$currentLocation) // use combine to assign location to currentLocation when available

        if ![.authorizedAlways, .authorizedWhenInUse]
            .contains(locationDataManager.authorizationStatus.value)
        {
            locationDataManager.authorizationStatus.sink(receiveValue: { status in
                if status == .authorizedAlways || status == .authorizedWhenInUse {
                    print("Requesting location updates")
                    self.locationDataManager.startUpdatingLocation()
                }

                if status == .denied {
                    self.appEnv?.locationAccessDenied = true
                }
            })
            .store(in: &cancellables)
        } else {
            print("Requesting location updates 2")
            locationDataManager.startUpdatingLocation()
        }
    }

    func checkLocationPermissions() {
        print("Check Permissions: \(locationDataManager.authorizationStatus.value)")
        if locationDataManager.authorizationStatus.value == .notDetermined {
            print("Location permissions not determined")
        }

        if ![.authorizedAlways, .authorizedWhenInUse]
            .contains(locationDataManager.authorizationStatus.value)
        {
            isLoading = false
            if locationDataManager.authorizationStatus.value == .denied {
                errorMessage = "Location permissions denied. No worries! You can still explore weather by entering a city name or address. Let's find the forecast for you! "
            }
        }
    }

    private func debounceLocationChanges() {
        $currentLocation
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [self] dL in
                print("Home: new location: \(String(describing: dL))")

                if shouldFetchLocalWeather {
                    getCurrentLocationWeather()
                }
            }
            .store(in: &cancellables)
    }

    func setup() {
        isLoading = true
        setupLocationManager()
        checkLocationPermissions()
        debounceLocationChanges()
    }
}

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completionItems = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func setEnv(appEnv: AppEnvironment) {
        self.appEnv = appEnv
    }

    func getCurrentLocationWeather() {
        if ![.authorizedAlways, .authorizedWhenInUse]
            .contains(authorizationStatus)
        {
            if authorizationStatus == .denied {
                appEnv?.showingLocationPrompt = true
                isLoading = false
                return
            } else {
                appEnv?.showingLocationPrompt = true
                isLoading = false
                return
            }
        }

        print("Fetching ")
        print("Current location: \(String(describing: currentLocation))")

        guard let userLocation = currentLocation else {
            appEnv?.showBanner(message: "Unable to fetch weather data.", hint: "Location unavailable")

            isLoading = false
            errorMessage = "Location unavailable."
            return
        }

        isLoading = true
        restoredLastSearch = false

        dataManager.getWeatherForLocation(location: userLocation.coordinate)
            .sink { [self] completion in
                switch completion {
                case .finished:
                    print("Fetching Current Location Weather complete")
                    isLoading = false
                case let .failure(error):
                    print("Fetching getCurrentLocationWeather error: \(error)")

                    appEnv?.showBanner(message: "Unable to fetch weather data.", hint: error.localizedDescription)

                    isLoading = false
                    shouldFetchLocalWeather = false
                    errorMessage = error.localizedDescription
                }
            } receiveValue: { [self] currentWeatherResponse in
                print("currentWeather: \(currentWeatherResponse)")
                currentWeather = currentWeatherResponse
                isLoading = false
                errorMessage = ""
                shouldFetchLocalWeather = false
            }
            .store(in: &cancellables)
    }

    func getWeatherForCity(location: MKLocalSearchCompletion) {
        completer.cancel()
        restoredLastSearch = false
        errorMessage = ""
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in

            guard error == nil else {
                self.appEnv?.showBanner(message: "Unable to find location from city.")
                return
            }

            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                self.searchLocation = coordinate
                self.getSelectedLocationWeather()
            }
        }
    }

    func getSelectedLocationWeather() {
        print("Selected location: \(String(describing: searchLocation))")

        guard let searchLocation = searchLocation else {
            appEnv?.showBanner(message: "Unable to fetch weather data.", hint: "Selected Location unavailable")

            isLoading = false
            errorMessage = "Location unavailable."
            return
        }

        isLoading = true

        dataManager.getWeatherForLocation(location: searchLocation)
            .sink { [self] completion in
                switch completion {
                case .finished:
                    print("Fetching Location Weather complete")
                    isLoading = false
                case let .failure(error):
                    print("Fetching Location weather error: \(error)")
                    appEnv?.showBanner(message: "Unable to fetch weather data.", hint: error.localizedDescription)
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            } receiveValue: { [self] currentWeatherResponse in
                print("currentWeather: \(currentWeatherResponse)")
                currentWeather = currentWeatherResponse
                isLoading = false
                errorMessage = ""
            }
            .store(in: &cancellables)
    }
}
