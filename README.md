# HereWeather iOS App


<img src='images/hereweather_icon.png' width='256'>

Welcome to the HereWeather App! This iOS application provides real-time weather information for cities around the world. It allows users to retrieve weather data by searching for a city name or address.

> 👉🏽 Please add API key in the Configuration.swift file for this app to work 👈🏽

## Features

- Get current weather conditions for current location
- Display temperature, wind speed, and more conditions
- Search by city name or address
- Clean and intuitive user interface
- Real-time data updates
- Remember last viewed city and fetch weather on launch
- Uses all the modern SwiftUI and Combine features with URL session and location manager
- Uses AppStorage for persistence
- Kingfisher module to load and cache images
- PopupView module to display views as popups 

## Installation

1. Clone the repository: `git clone https://github.com/logesh45/HereWeather.git`
2. Open the project in Xcode: `open HereWeather.xcodeproj`
3. Configure the OpenWeather API key in `Configuration.swift`
3. Build and run the app on the iOS Simulator or a connected device.

## Usage

1. Launch the App on the iOS Simulator or your device.
2. Allow location access to display weather for current location.
3. Enter a city name or address in the search bar.
4. Tap on a suggested city or address from list.
5. The current weather information for the specified location will be displayed.
6. When app is closed and relaunched, it displays weather for the last viewed city or address.

