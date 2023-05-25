//
//  WeatherCard.swift
//  HereWeather
//
//  Created by Logesh R on 24/05/23.
//

import Kingfisher
import SwiftUI

struct WeatherCard: View {
    let currentWeather: CurrentWeatherResponse

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    KFImage.url(URL(string: "https://openweathermap.org/img/wn/\(currentWeather.weather[0].icon)@2x.png"))
                        .placeholder {
                            ZStack {
                                ProgressView()
                            }
                        }

                        .resizable()
                        .retry(maxCount: 3, interval: .seconds(10))
                        .cancelOnDisappear(true)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                        .padding()
                }
                VStack {
                    HStack {
                        Text("\(currentWeather.name), \(currentWeather.sys.country)")
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                       
                    }

                    HStack {
                        Text("\(currentWeather.weather[0].main)")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Wind Speed \(currentWeather.wind.speed, specifier: "%.2f") mph")
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        }
                            .padding(.vertical, 4)
                    }
                    HStack {
                        HStack {
                            Text("\(currentWeather.main.temp, specifier: "%.0f") ºF")
                                .font(.title2)
                                .bold()

                            Text("H: \(currentWeather.main.tempMax, specifier: "%.0f") ºF")
                                .bold()
                                .foregroundColor(.secondary)

                            Text("L:  \(currentWeather.main.tempMin, specifier: "%.0f") ºF")
                                .bold()
                                .foregroundColor(.secondary)

                            Spacer()
                        }
                    }
                }
                .padding(32)
            }

            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            .gradientColor1,
                            .gradientColor2
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottom
                    ))
                    .shadow(
                        color: Color.gray.opacity(0.2), radius: 25, x: 0, y: 8
                    )
            )
        }
        .frame(maxWidth: .infinity)
    }
}

struct WeatherCard_Previews: PreviewProvider {
//    static var viewModel: GroupDetailsViewModel {
//        GroupDetailsViewModel(groupManager: MockGroupManager())
//    }

    static var previews: some View {
        WeatherCard(
            currentWeather: MockDataManager().currentWeather)
            .padding()
//            .previewLayout(.sizeThatFits)
    }
}

struct CustomCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
