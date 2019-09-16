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
    
  
    @IBOutlet weak var locationLabel: UILabel!
    
    let networkingProvider = MoyaProvider<NetworkingService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        getWeather(coords: Cordinate.alcatrazIsland)
    }
    
    fileprivate func getWeather(coords: Cordinate){
        print("Get the weather")
        networkingProvider.request(.CurrentWeather(coordinate: coords)) { (result) in
            switch result {
            case .success(let response):
                do{
                    let currentWeather = try JSONDecoder().decode(Weather.self, from: response.data)
                        let viewModel = CurrentWeatherViewModel(model: currentWeather.currently)
                    print(viewModel)
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
        print("display weather")
        currentTemperatureLabel.text = viewModel.temperature
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = viewModel.precipitationProbability
        currentWeatherIcon.image = viewModel.icon
        currentSummaryLabel.text = viewModel.summary
        
        
    }

    @IBAction func getCurrentWeather() {
        getWeather(coords: Cordinate.alcatrazIsland)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        print("Search button pressed.")
    }

    fileprivate func toggleRefreshAnimation(on: Bool){
        refreshButton.isHidden = on
        if (on == true) {
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchPressed"{
            let searchVC = segue.destination as! SearchViewController
            searchVC.placeSelectionDelegate = self
        }
    }
}

extension ViewController: PlaceSelectionDelegate{
    func placeSelected(with lat: Double, with lng: Double, with place: String) {
        let cords = Cordinate.init(latitude: lat, longitude: lng)
        locationLabel.text = place
        getWeather(coords: cords)
    }
}













