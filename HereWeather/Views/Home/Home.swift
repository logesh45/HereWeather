//
//  Home.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import CoreLocation
import SwiftUI

struct Home: View {
    @StateObject var viewModel = HomeViewModel()
    @EnvironmentObject var appEnv: AppEnvironment

    @AppStorage("LAST_LOCATION_LAT") var lastLocationLat: Double = 0.0
    @AppStorage("LAST_LOCATION_LONG") var lastLocationLong: Double = 0.0

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    VStack {
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .padding()
                                Text("Weather incoming! Stand by for the forecast. ⛅️")
                            }
                        } else {
                            if let currentWeather = viewModel.currentWeather {
                                WeatherCard(currentWeather: currentWeather)
                                    .padding()
                                if viewModel.restoredLastSearch {
                                    Text("City restored! Welcome back to your last searched location. 🏙️")
                                        .padding()
                                }
                                Spacer()
                            }
                        }
                    }
                    List(viewModel.completionItems, id: \.self) { item in
                        Button(item.title) {
                            viewModel.completionItems = []
                            viewModel.getWeatherForCity(location: item)
                            hideKeyboard()
                        }
                    }
                }
                if viewModel.errorMessage != "" {
                    Spacer()
                    Text(viewModel.errorMessage)
                        .padding()
                    Spacer()
                }
            }
            .onChange(of: viewModel.authorizationStatus) { newValue in

                print("authorizationStatus changed New Value: \(newValue)")

                if newValue == .authorizedAlways ||
                    newValue == .authorizedWhenInUse
                {
                    appEnv.showingLocationPrompt = false
                    appEnv.locationAccessDenied = false
                } else {
                    if newValue == .denied {
                        appEnv.locationAccessDenied = true
                        viewModel.errorMessage = "Location permissions denied. No worries! You can still explore weather by entering a city name or address. Let's find the forecast for you! "
                    }
                }
            }
            .onChange(of: viewModel.searchText) { newValue in
                if newValue != "" {
                    viewModel.completer.queryFragment = newValue
                } else {
                    viewModel.completionItems = []
                }
            }
            .onChange(of: viewModel.searchLocation?.latitude) { newValue in
                if let lastLocation = newValue {
                    lastLocationLat = lastLocation
                }
            }
            .onChange(of: viewModel.searchLocation?.longitude) { newValue in
                if let lastLocation = newValue {
                    lastLocationLong = lastLocation
                }
            }
            .onAppear {
                viewModel.setEnv(appEnv: appEnv)
                viewModel.setup()
                if lastLocationLat != 0.0 && lastLocationLong != 0.0 {
                    viewModel.searchLocation = CLLocationCoordinate2D(latitude: lastLocationLat, longitude: lastLocationLong)
                    viewModel.getSelectedLocationWeather()
                    viewModel.shouldFetchLocalWeather = false
                    viewModel.restoredLastSearch = true
                } else {
                    viewModel.shouldFetchLocalWeather = true
                    viewModel.restoredLastSearch = false
                }
            }
            .searchable(text: $viewModel.searchText,
                        placement: .navigationBarDrawer(
                            displayMode: .always
                        ),
                        prompt: "Search by city name")

            .navigationTitle("Hello there! ")
            .toolbar {
                Button {
                    viewModel.getCurrentLocationWeather()
                    lastLocationLat = 0.0
                    lastLocationLong = 0.0
                }
                    label: {
                    Label("Current Location", systemImage: "location.fill")
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(dataManager: MockDataManager())

        Home(viewModel: viewModel)
            .padding()
            .environmentObject(AppEnvironment())
    }
}
