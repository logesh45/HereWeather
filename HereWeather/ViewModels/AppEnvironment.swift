//
//  AppEnvironment.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import SwiftUI
import CoreLocation

class AppEnvironment: ObservableObject {
    static let shared = AppEnvironment()

    @Published var showingLocationPrompt = false
    @Published var showingPopup = false
    
    @Published var locationAccessDenied = false

    @Published var errorImage: String = "info.circle.fill"
    @Published var errorMessage: String = ""
    @Published var errorHint: String = ""
    @Published var errorColor: Color = .red
    
    func showBanner(
        image: String? = "info.circle.fill",
        message: String,
        hint: String? = "",
        color: Color? = .red
    ) {
        hideKeyboard()
        
        if let image = image {
            errorImage = image
        }

        if let color = color {
            errorColor = color
        }

        errorMessage = message

        if let hint = hint {
            errorHint = hint
        }
        showingPopup = true
    }
    
    func createBottomToast() -> some View {
        VStack {
            HStack(spacing: 16) {
                Spacer()
                Image(systemName: errorImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)

                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {
                    Text(errorMessage)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(errorHint)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(errorColor)
    }
    
    func requestLocationAuthorization() {
        let manager = CLLocationManager()
        let locationDataManager = LocationDataManager(locationManager: manager)
        locationDataManager.requestAuthorization()
    }
}
