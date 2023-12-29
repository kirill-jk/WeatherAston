//
//  WeatherData.swift
//  WeatherAston
//
//  Created by Кирилл Курилюк on 29.12.2023.
//

import Foundation

// MARK: - Weather
struct WeatherData: Decodable {
	let list: [List]
	let city: City
}

// MARK: - City
struct City: Decodable {
	let name: String
}


// MARK: - List
struct List: Decodable {
	let dt: Int
	let main: MainClass
	let weather: [WeatherElement]
}


// MARK: - MainClass
struct MainClass: Decodable {
	let temp: Double
}




// MARK: - WeatherElement
struct WeatherElement: Decodable {
	let id: Int
}


