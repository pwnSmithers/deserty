//
//  SearchViewController.swift
//  Stormy
//
//  Created by Smithers on 06/09/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        print("Hello Search")
        searchResultsTableView.isHidden = true
    }
    
    
    
}


