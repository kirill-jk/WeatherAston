//
//  ViewController.swift
//  WeatherAston
//
//  Created by Кирилл Курилюк on 29.12.2023.
//


import UIKit
import CoreLocation
import SnapKit
import RxCocoa
import RxSwift

private enum Constants {
	static let backgroundImageName = "background"
	static let placeholderText = "Search"
	static let locationButtonImage = "location.circle.fill"
	static let searchButtonImage = "magnifyingglass"
	static let standardFont = CGFloat(20)
	static let textForAddButton = "Add to favorite"
	static let cityKey = "CityKey"
}

class WeatherViewController: UIViewController {
	
	let locationManager = CLLocationManager()
	var weatherManager = WeatherNetworkService()

	
	private lazy var backgroundImage: UIImageView = {
		let image = UIImage(named: Constants.backgroundImageName)
		let imageView = UIImageView()
		imageView.image = image
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false


		return imageView
	}()
	private var searchTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = Constants.placeholderText
		textField.textAlignment = .right
		textField.textColor = .white
		textField.font = UIFont.systemFont(ofSize: Constants.standardFont)
		textField.returnKeyType = .search
		textField.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 0.41)
		return textField
	}()
	private lazy var cityLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
//		label.text = ""
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return label
	}()
	private lazy var temperatureLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 45)
		return label
	}()
	private let locationButton: UIButton = {
		let button = UIButton(type: .system)
		button.clipsToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setBackgroundImage(UIImage(systemName: Constants.locationButtonImage), for: .normal)
		button.tintColor = .white
		return button
	}()
	private let addFavoriteCity: UIButton = {
		let button = UIButton(type: .system)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.numberOfLines = 0
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return button
	}()
	
	private lazy var weatherImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .white
		return imageView
	}()
	private let searchButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setBackgroundImage(UIImage(systemName: Constants.searchButtonImage), for: .normal)
		button.tintColor = .white
		return button
	}()
	private lazy var dayOneDate: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return label
	}()
	private lazy var tempForDayOne: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return label
	}()
	private lazy var dayTwoDate: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return label
	}()
	private lazy var tempForDayTwo: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return label
	}()
	private lazy var dayThreeDate: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return label
	}()
	private lazy var tempForDayThree: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return label
	}()
	private let favoriteCityButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.numberOfLines = 0
		button.setTitle("Go to \(UserDefaults.standard.string(forKey: Constants.cityKey) ?? "")", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.standardFont)
		button.isHidden = true
		return button
	}()
	
	
	private var favoriteCity = ""
	let disposeBag = DisposeBag()
	private let viewModel = WeatherViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		searchTextField.delegate = self
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		setupUI()
		updateUI()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
	
	private func setupUI() {
		
		view.addSubview(backgroundImage)
		view.addSubview(locationButton)
		view.addSubview(searchTextField)
		view.addSubview(searchButton)
		view.addSubview(addFavoriteCity)
		view.addSubview(weatherImage)
		view.addSubview(temperatureLabel)
		view.addSubview(cityLabel)
		view.addSubview(dayOneDate)
		view.addSubview(tempForDayOne)
		view.addSubview(dayTwoDate)
		view.addSubview(tempForDayTwo)
		view.addSubview(dayThreeDate)
		view.addSubview(tempForDayThree)
		view.addSubview(favoriteCityButton)
		
		backgroundImage.snp.makeConstraints { make in
			make.top.left.equalToSuperview()
			make.right.bottom.equalToSuperview()
		}
		
		locationButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(50)
			make.left.equalToSuperview().offset(20)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		searchTextField.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(50)
			make.left.equalTo(locationButton.snp.right)
			make.right.equalTo(searchButton.snp.left)

			make.height.equalTo(40)
		}
		searchButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(50)
			make.right.equalToSuperview().inset(20)
			make.width.height.equalTo(40)
		}
		addFavoriteCity.snp.makeConstraints { make in
			make.top.equalTo(locationButton).offset(50)
			make.left.equalToSuperview().offset(20)
			
		}
		
		weatherImage.snp.makeConstraints { make in
			make.top.equalTo(searchButton).offset(50)
			make.right.equalToSuperview().inset(20)
			make.width.height.equalTo(75)
		}
		
		temperatureLabel.snp.makeConstraints { make in
			make.top.equalTo(weatherImage.snp.bottom).offset(20)
			make.right.equalToSuperview().inset(20)
		}
		cityLabel.snp.makeConstraints { make in
			make.top.equalTo(temperatureLabel.snp.bottom).offset(20)
			make.right.equalToSuperview().inset(20)
		}
		
		dayOneDate.snp.makeConstraints { make in
			make.top.equalTo(cityLabel.snp.bottom).offset(30)
			make.left.equalToSuperview().offset(20)
		}
		
		tempForDayOne.snp.makeConstraints { make in
			make.top.equalTo(cityLabel.snp.bottom).offset(30)
			make.right.equalToSuperview().inset(20)
		}
		
		dayTwoDate.snp.makeConstraints { make in
			make.top.equalTo(dayOneDate.snp.bottom).offset(30)
			make.left.equalToSuperview().offset(20)
		}
		
		tempForDayTwo.snp.makeConstraints { make in
			make.top.equalTo(tempForDayOne.snp.bottom).offset(30)
			make.right.equalToSuperview().inset(20)
		}
		
		dayThreeDate.snp.makeConstraints { make in
			make.top.equalTo(dayTwoDate.snp.bottom).offset(30)
			make.left.equalToSuperview().offset(20)
		}
		
		tempForDayThree.snp.makeConstraints { make in
			make.top.equalTo(tempForDayTwo.snp.bottom).offset(30)
			make.right.equalToSuperview().inset(20)
		}
		favoriteCityButton.snp.makeConstraints { make in
			make.top.equalTo(tempForDayThree.snp.bottom).offset(30)
			make.right.equalToSuperview().inset(20)
		}
		
		locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
		searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
		addFavoriteCity.addTarget(self, action: #selector(addFavoriteCityPressed), for: .touchUpInside)
		favoriteCityButton.addTarget(self, action: #selector(favoriteCityButtonPressed), for: .touchUpInside)

	}
	
	private func updateUI() {
		viewModel.weatherData.subscribe { [weak self] event in
			DispatchQueue.main.async {
				if let weather = event.element {
					self?.temperatureLabel.text = "\(weather.temperatureString0)°C"
					self?.weatherImage.image = UIImage(systemName: weather.conditionName)
					self?.cityLabel.text = ("\(weather.currentDate) - \(weather.cityName)")
					self?.dayOneDate.text = weather.dateForFirstDay
					self?.dayTwoDate.text = weather.dateForSenondDay
					self?.dayThreeDate.text = weather.dateForThirdDay
					self?.tempForDayTwo.text = "\(weather.temperatureString2)°C"
					self?.tempForDayOne.text = "\(weather.temperatureString1)°C"
					self?.tempForDayThree.text = "\(weather.temperatureString3)°C"
					self?.addFavoriteCity.setTitle(Constants.textForAddButton, for: .normal)
					self?.favoriteCity = weather.cityName
					self?.favoriteCityButton.isHidden = false
				}
			}
		}.disposed(by: disposeBag)
	}
	@objc private func addFavoriteCityPressed() {
		print(favoriteCity)
		favoriteCityButton.setTitle("Go to \(favoriteCity)", for: .normal)
		UserDefaults.standard.set(favoriteCity, forKey: Constants.cityKey)
	}
	
	@objc private func favoriteCityButtonPressed() {
		let controller = FavoriteCityVC()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
	@objc private func searchButtonPressed() {
		searchTextField.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchTextField.endEditing(true)
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			textField.placeholder = "Type something"
			return false
		}
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		if let city = searchTextField.text {
			viewModel.getWeatherByCity(city: city)
			weatherManager.fetchWeather(cityName: city)
		}
		searchTextField.text = ""
	}
	
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
	
	@objc private func locationButtonPressed() {
		locationManager.requestLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			locationManager.stopUpdatingLocation()
			let lat = location.coordinate.latitude
			let lon = location.coordinate.longitude
			viewModel.getWeatherByLocation(lat: lat, lon: lon)
		}
	}
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}
