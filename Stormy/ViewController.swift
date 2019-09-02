//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 5/8/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    fileprivate let privateKey = "a68b537824d2345180201e3902397d6a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInfo()
    }

    fileprivate func showInfo(){
       
        let base = URL(string: "https://api.darksky.net/forecast/\(privateKey)/")
        guard let forecastUrl = URL(string: "37.8267,-122.4233", relativeTo: base) else {
            return
        }
        
        let request = URLRequest(url: forecastUrl)
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request) { data, response, error  in
            print(data)
        }
        
        dataTask.resume()
        
        let currentWeatherInst = CurrentWeather(temperature: 85.0, humidity: 0.8, precipProbability: 0.1, summary: "Bloody Fucking Hot", icon: "clear-day")
        let viewModel = CurrentWeatherViewModel(model: currentWeatherInst)
        displayWeather(using: viewModel)
    }
    
    fileprivate func displayWeather(using viewModel: CurrentWeatherViewModel){
        currentTemperatureLabel.text = viewModel.temperature
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = viewModel.precipitationProbability
        currentWeatherIcon.image = viewModel.icon
        currentSummaryLabel.text = viewModel.summary
        
    }

}















