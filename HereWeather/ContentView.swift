//
//  ContentView.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import PopupView
import SwiftUI

struct ContentView: View {
    @StateObject var appEnv = AppEnvironment.shared

    var body: some View {
        Home()
            .popup(isPresented: $appEnv.showingPopup) {
                appEnv.createBottomToast()
            } customize: {
                $0
                    .type(.toast)
                    .position(.bottom)
                    .autohideIn(3)
            }
            .popup(isPresented: $appEnv.showingLocationPrompt) {
                LocationPrompt()
            } customize: { $0
                .type(.toast)
                .position(.bottom)
                .animation(.easeInOut(duration: 0.25))
                .closeOnTap(false)
            }
            .environmentObject(appEnv)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
