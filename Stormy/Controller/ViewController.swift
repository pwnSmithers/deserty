//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 5/8/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import Moya
class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let networkingProvider = MoyaProvider<NetworkingService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        getWeather()
    }
    
    fileprivate func getWeather(){
        networkingProvider.request(.CurrentWeather(coordinate: Cordinate.alcatrazIsland)) { (result) in
            switch result {
            case .success(let response):
                do{
                    let currentWeather = try JSONDecoder().decode(Weather.self, from: response.data)
                        let viewModel = CurrentWeatherViewModel(model: currentWeather.currently)
                    DispatchQueue.main.async {
                        self.displayWeather(using: viewModel)
                        self.toggleRefreshAnimation(on: false)
                    }
                }catch let error {
                   print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func displayWeather(using viewModel: CurrentWeatherViewModel){
        currentTemperatureLabel.text = viewModel.temperature
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = viewModel.precipitationProbability
        currentWeatherIcon.image = viewModel.icon
        currentSummaryLabel.text = viewModel.summary
        
    }

    @IBAction func getCurrentWeather() {
        getWeather()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        print("Search button pressed.")
    }

    fileprivate func toggleRefreshAnimation(on: Bool){
        refreshButton.isHidden = on
        if on {
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
}















