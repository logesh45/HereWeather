//
//  LocationPrompt.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import SwiftUI

struct LocationPrompt: View {
    @EnvironmentObject var appEnv: AppEnvironment

    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss

    func getLocationAccessText() -> String {
        return appEnv.locationAccessDenied ?
            "Please grant location access for location features. HereWeather utilizes your location data to display weather in your location. Rest assured, we will only use this information for this specific purpose and will not store your location history."
            :
            "HereWeather works by accessing your current location data to display current weather. Please grant location permissions."
    }

    var body: some View {
        VStack {
            Image(systemName: "location.magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 64)
                .padding()

            VStack {
                Text("Location access \(appEnv.locationAccessDenied ? "required" : "")")
                    .fontWeight(.bold)
                    .font(.title2)
                Text(getLocationAccessText())
                    .lineLimit(5)
                    .font(.caption)
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
            }
            if appEnv.locationAccessDenied {
                Button(action: {
                    appEnv.showingLocationPrompt = false
                }) {
                    Text("Continue without location")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(8)
            } else {
                Button(action: {
                    print("Requesting location access")
                    appEnv.requestLocationAuthorization()
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("info_bg"))
                .shadow(color: Color.shadow, radius: 16, x: 0, y: 0)
        )
        .padding()
    }
}

struct LocationPrompt_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self, content:
            LocationPrompt()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme)
            .environmentObject(AppEnvironment())
    }
}
