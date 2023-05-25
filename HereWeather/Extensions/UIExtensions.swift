//
//  UIExtensions.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import SwiftUI

func hideKeyboard() {
    UIApplication.shared
        .sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
