//
//  WeatherNetworkService.swift
//  WeatherAston
//
//  Created by Кирилл Курилюк on 29.12.2023.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift


private enum Constants {
	static let baseURL = "https://api.openweathermap.org/data/2.5/forecast?&appid=d6880538c375d900fdce78998ed676e6&units=metric"
	static let currentDay = 0
	static let dayOne = 7
	static let dayTwo = 15
	static let dayThree = 23
	static let dateFormat = "dd.MM.yyyy"
}

final class WeatherNetworkService {
	
	var weatherData = PublishRelay<WeatherModel>()
	
	func fetchWeather(cityName: String) {
		let urlString = "\(Constants.baseURL)&q=\(cityName)"
		performRequest(with: urlString)
	}
	
	func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
		let urlString = "\(Constants.baseURL)&lat=\(latitude)&lon=\(longitude)"
		performRequest(with: urlString)
	}
	
	func performRequest(with urlString: String) {
		
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url) { data, response, error in
				guard error == nil else { return }
				if let safeData = data {
					if let weather = self.parseJSON(safeData) {
						self.weatherData.accept(weather)
					}
				}
			}
			task.resume()
		}
	}
	
	func parseJSON(_ weatherData: Data) -> WeatherModel? {
		
		let decoder = JSONDecoder()
		do {
			let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
			let id = decodedData.list[0].weather[0].id
			let name = decodedData.city.name
			let currentDate = decodedData.list[Constants.currentDay].dt
			let firstDate = decodedData.list[Constants.dayOne].dt
			let secondDate = decodedData.list[Constants.dayTwo].dt
			let thirdDate = decodedData.list[Constants.dayThree].dt
			let currentDayTemp = decodedData.list[Constants.currentDay].main.temp
			let dayOneTemp = decodedData.list[Constants.dayOne].main.temp
			let dayTwoTemp = decodedData.list[Constants.dayTwo].main.temp
			let dayThreeTemp = decodedData.list[Constants.dayThree].main.temp
			let formatter = DateFormatter()
			formatter.dateFormat = Constants.dateFormat
			
			let dateForCurrent = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(currentDate)))
			let dateForFirst = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(firstDate)))
			let dateForSecond = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(secondDate)))
			let dateForThird = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(thirdDate)))

			let weather = WeatherModel(conditionID: id, cityName: name, currentDate: dateForCurrent, dateForFirstDay: dateForFirst, dateForSenondDay: dateForSecond, dateForThirdDay: dateForThird, temperatureForCurrentDay: currentDayTemp, temperatureForFirstDay: dayOneTemp, temperatureForSecondDay: dayTwoTemp, temperatureForThirdDay: dayThreeTemp)
			return weather
		} catch {
			return nil
		}
	}
}
