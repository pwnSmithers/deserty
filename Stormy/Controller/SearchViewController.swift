//
//  SearchViewController.swift
//  Stormy
//
//  Created by Smithers on 06/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation
import UIKit
import Moya

protocol PlaceSelectionDelegate {
    func placeSelected(with lat: Double, with lng: Double, with place: String)
}

class SearchViewController: UIViewController {
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var placeSelectionDelegate : PlaceSelectionDelegate!

    let placeArray = ["Najjera", "Damacia", "kigalia", "Kyebando", "kyengera"]
    let networkingProvider = MoyaProvider<NetworkingService>()
    
    var sexyResults = [Results]()
    
    @IBAction func suggestionOneButton(_ sender: Any) {
        getGeocoding(of: "Najjera")
    }
    
    @IBAction func suggestionTwoButton(_ sender: Any) {
        getGeocoding(of: "Kisaasi")
    }
    
    @IBAction func suggestionThreeButton(_ sender: Any) {
        getGeocoding(of: "Makerere")
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        searchResultsTableView.isHidden = true
    }
    
    fileprivate func getGeocoding(of place: String){
        
        networkingProvider.request(.Geocoding(place: place)) { (result) in
            switch result {
            case .success(let response):
                do{
                    print(response.data)
                    let coordinates = try JSONDecoder().decode(Results.self, from: response.data)
                    DispatchQueue.main.async {
                         self.sexyResults.append(coordinates)
                         self.searchResultsTableView.reloadData()
                         self.searchResultsTableView.isHidden = false
                    }
                }catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}


extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sexyResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.textColor = UIColor.white
        if sexyResults.isEmpty {
            cell?.textLabel?.text = "We couldn't find the place you're searching for."
        }else{
            sexyResults.forEach { place in
                place.results.forEach({ x in
                    cell?.textLabel?.text = x.formatted_address
                })
            }
        }
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let place = sexyResults[indexPath.row].results
        place.forEach { x in
            let geometry = x.geometry.location
            print(geometry)
            placeSelectionDelegate.placeSelected(with: geometry.lat, with: geometry.lng, with: x.formatted_address)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        print(searchText)
        getGeocoding(of: searchText)
    }
    
}
