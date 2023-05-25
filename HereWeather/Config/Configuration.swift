//
//  Configuration.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import Foundation

enum Config {
    static var baseURL: String {
        return "https://" + "api.openweathermap.org" // setup infoplist with build schemes to switch url when changing build schemes
    }

    static var accessKey: String {
        return "<apikey>" // get accesskeys from server for security after authentication. using in-line for demo
    }
}
