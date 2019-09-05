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
    
    fileprivate let client = DarkSkyApiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInfo()
        activityIndicator.isHidden = true
    }

    fileprivate func showInfo(){
        toggleRefreshAnimation(on: true)
        client.getCurrentWeather(at: Cordinate.alcatrazIsland) { [unowned self] currentWeather, error in
            if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)
                self.toggleRefreshAnimation(on: false)
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
        
        print("Current weather")
        showInfo()
        
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















