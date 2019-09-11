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

class SearchViewController: UIViewController {
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let placeArray = ["Najjera", "Damacia", "kigalia", "Kyebando", "kyengera"]
    let networkingProvider = MoyaProvider<NetworkingService>()
    let provider = MoyaProvider<NetworkingService>(plugins: [CompleteUrlLoggerPlugin()])
    
    @IBAction func suggestionOneButton(_ sender: Any) {
        print("one")
    }
    
    @IBAction func suggestionTwoButton(_ sender: Any) {
        print("Two")
    }
    
    @IBAction func suggestionThreeButton(_ sender: Any) {
        print("Three")
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
    }
    
    fileprivate func getGeocoding(of place: String){
        
        networkingProvider.request(.Geocoding(place: place)) { (result) in
            switch result {
            case .success(let response):
                do{
                    print(response.data)
                    let coordinates = try JSONDecoder().decode(Results.self, from: response.data)
                   
                    print(coordinates)
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
        return placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = placeArray[indexPath.row]
        return cell!
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        print(searchText)
        getGeocoding(of: searchText)
    }
    
}
