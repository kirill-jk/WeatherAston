//
//  FavoriteCityVC.swift
//  WeatherAston
//
//  Created by Кирилл Курилюк on 29.12.2023.
//


import UIKit
import SnapKit
import RxCocoa
import RxSwift

private enum Constants {
	static let backgroundImageName = "background"
	static let locationButtonImage = "location.circle.fill"
	static let searchButtonImage = "magnifyingglass"
	static let standardFont = CGFloat(20)
	static let cityKey = "CityKey"
}


class FavoriteCityVC: UIViewController {
	
	private lazy var backgroundImage: UIImageView = {
		let image = UIImage(named: Constants.backgroundImageName)
		let imageView = UIImageView()
		imageView.image = image
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		return imageView
	}()
	
	private lazy var cityLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
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
	private let backButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.numberOfLines = 0
		button.setTitle("Back", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.standardFont)
		return button
	}()

	
	let disposeBag = DisposeBag()
	private let viewModel = FavoriteCityViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		updateUI()
		viewModel.getWeatherByCity(city: UserDefaults.standard.string(forKey: Constants.cityKey) ?? "London")
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	private func setupUI() {
		
		view.addSubview(backgroundImage)
		view.addSubview(weatherImage)
		view.addSubview(temperatureLabel)
		view.addSubview(cityLabel)
		view.addSubview(dayOneDate)
		view.addSubview(tempForDayOne)
		view.addSubview(dayTwoDate)
		view.addSubview(tempForDayTwo)
		view.addSubview(dayThreeDate)
		view.addSubview(tempForDayThree)
		view.addSubview(backButton)
		
		backgroundImage.snp.makeConstraints { make in
			make.top.left.equalToSuperview()
			make.right.bottom.equalToSuperview()
		}
		
		backButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(50)
			make.left.equalToSuperview().offset(20)
		}
		weatherImage.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(50)
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
		
		backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
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
				}
			}
		}.disposed(by: disposeBag)
	}
	@objc private func backButtonPressed() {
		navigationController?.popViewController(animated: true)
	}
}

