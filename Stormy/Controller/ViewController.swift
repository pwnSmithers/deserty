//
//  ViewController.swift
//  Stormy
//
//  Created by Smithers on 18/8/19.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import Moya
import CoreLocation



class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
  
    @IBOutlet weak var locationLabel: UILabel!
    
    
    let networkingProvider = MoyaProvider<NetworkingService>()
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.requestLocation()
        activityIndicator.isHidden = true
        getWeather(coords: Cordinate.alcatrazIsland)
    }
    
    fileprivate func getWeather(coords: Cordinate){
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
        currentTemperatureLabel.text = viewModel.temperature
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = "\(viewModel.precipitationProbability)%"
        currentWeatherIcon.image = viewModel.icon
        currentSummaryLabel.text = viewModel.summary
    }
    
    fileprivate func getLocation(with lat: Double, with lng: Double){
        
        networkingProvider.request(.ReverseGeocoding(lat: lat, lng: lng)) { (result) in
            switch result{
            case .success(let response):
                do{
                    let currentLocation = try JSONDecoder().decode(Results.self, from: response.data)
                    currentLocation.results.forEach({ x in
                        self.locationLabel.text = x.formatted_address
                    })
                    print(currentLocation)
                }catch let error {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    @IBAction func getCurrentWeather() {
        getWeather(coords: Cordinate.alcatrazIsland)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
      
    }

    fileprivate func toggleRefreshAnimation(on: Bool){
        refreshButton.isHidden = on
        if (on == true) {
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { location in
            getLocation(with: location.coordinate.latitude, with: location.coordinate.longitude)
            getWeather(coords: Cordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("The device failed to get the user's location \(error.localizedDescription)")
        
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
