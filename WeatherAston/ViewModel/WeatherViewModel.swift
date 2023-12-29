//
//  WeatherViewModel.swift
//  WeatherAston
//
//  Created by Кирилл Курилюк on 29.12.2023.
//


import UIKit
import RxCocoa
import RxSwift
import CoreLocation

final class WeatherViewModel {
	
	let weatherData = PublishRelay<WeatherModel>()
	let weatherService = WeatherNetworkService()
	let disposeBag = DisposeBag()

	init() {
		weatherService.weatherData.subscribe { event in
			self.weatherData.accept(event)
		}.disposed(by: disposeBag)
	}
	func getWeatherByCity(city: String) {
		weatherService.fetchWeather(cityName: city)
	}
	
	func getWeatherByLocation(lat: CLLocationDegrees, lon: CLLocationDegrees) {
		weatherService.fetchWeather(latitude: lat, longitude: lon)
	}
}
