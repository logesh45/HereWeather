//
//  OpenWeatherAPI.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import SwiftUI
import CoreLocation
import Combine

enum OWError: LocalizedError {
    case statusCodeError(code: Int, message: String)
    case generalError(message: String)
}

extension OWError {
    var errorDescription: String? {
        switch self {
        case .statusCodeError(code: _, message: let message):
            return NSLocalizedString("\(message)", comment: "Status code sent by server not 200.")
        case .generalError(message: let message):
            return NSLocalizedString("\(message)", comment: message)
        }
    }
}

class OpenWeatherAPI {
    static let instance = OpenWeatherAPI()

    // Get this from config for switching between dev/prod servers when changing Build schemes
    private let baseURL: String = Config.baseURL

    private static let getCurrentLocationWeatherEndpoint = "/data/2.5/weather"

    func getWeatherForLocation(location: CLLocationCoordinate2D) -> AnyPublisher<CurrentWeatherResponse, Error> {
        let urlString = baseURL + OpenWeatherAPI.getCurrentLocationWeatherEndpoint

        var urlComponents = URLComponents(string: urlString)

        urlComponents?.queryItems = [
            URLQueryItem(name: "lat", value: String(location.latitude)),
            URLQueryItem(name: "lon", value: String(location.longitude)),
            URLQueryItem(name: "units", value: "imperial"), // for USA units
            URLQueryItem(name: "appid", value: Config.accessKey)
        ]

        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap {
                    guard let httpResponse = $0.response as? HTTPURLResponse else {
                        print("getCurrentLocationWeather: Response was not an HTTPURLResponse.")
                        throw OWError.generalError(message: "Unable to read error response")
                    }

                    if httpResponse.statusCode != 200 {
                        let error = OWError.statusCodeError(code: httpResponse.statusCode, message: "Unable to process request, please try again. (Status \(httpResponse.statusCode))")
                        throw error
                    }

                    print("Received HTTP status: \(httpResponse.statusCode).")
                    return $0.data
                }
                .decode(type: CurrentWeatherResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
}
