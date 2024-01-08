//
//  FavoriteCityViewModel.swift
//  WeatherAston
//
//  Created by Кирилл Курилюк on 29.12.2023.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation

protocol IFavoriteCityViewModel {
	func getWeatherByCity(city: String)
}

final class FavoriteCityViewModel: IFavoriteCityViewModel {
	
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

}

