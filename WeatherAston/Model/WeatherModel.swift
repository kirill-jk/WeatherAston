//
//  WeatherModel.swift
//  WeatherAston
//
//  Created by Кирилл Курилюк on 29.12.2023.
//

import Foundation

struct WeatherModel {
	let conditionID: Int
	let cityName: String
	let currentDate: String
	let dateForFirstDay: String
	let dateForSenondDay: String
	let dateForThirdDay: String
	let temperatureForCurrentDay: Double
	let temperatureForFirstDay: Double
	let temperatureForSecondDay: Double
	let temperatureForThirdDay: Double
	
	var temperatureString0: String {
		return String(format: "%.1f", temperatureForCurrentDay)
	}
	var temperatureString1: String {
		return String(format: "%.1f", temperatureForFirstDay)
	}
	var temperatureString2: String {
		return String(format: "%.1f", temperatureForSecondDay)
	}
	var temperatureString3: String {
		return String(format: "%.1f", temperatureForThirdDay)
	}
	var conditionName: String {
		switch conditionID {
				case 200...232:
					return "cloud.bolt"
				case 300...321:
					return "cloud.drizzle"
				case 500...531:
					return "cloud.rain"
				case 600...622:
					return "cloud.snow"
				case 701...781:
					return "cloud.fog"
				case 800:
					return "sun.max"
				case 801...804:
					return "cloud.bolt"
				default:
					return "cloud"
				}
	}
}
