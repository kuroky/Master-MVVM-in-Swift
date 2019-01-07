//
//  AddLocationViewController.swift
//  Sky
//
//  Created by kuroky on 2019/1/7.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddLocationViewControllerDelegate {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}

class AddLocationViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    private var locations: [Location] = []
    
    var delegate: AddLocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add a location"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
}


extension AddLocationViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Unexpected table view cell")
        }
        
        let location = locations[indexPath.row]
        let vm = LocationsViewModel.init(location: location.location, locationText: location.name)
        cell.configItem(item: vm)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let location = locations[indexPath.row]
        self.delegate?.controller(self, didAddLocation: location)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.geocode(address: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.locations = []
        self.tableView.reloadData()
    }
    
    private func geocode(address: String?) {
        guard let address = address else {
            locations = []
            self.tableView.reloadData()
            return
        }
        
        CLGeocoder().geocodeAddressString(address) { [weak self] (placemarks, error) in
            DispatchQueue.main.async {
                self?.processResponse(with: placemarks, error: error)
            }
        }
    }
    
    private func processResponse(with placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Cannot handle Geocode Address! \(error)")
        }
        else if let results = placemarks {
            locations = results.compactMap {
                result -> Location? in
                guard let name = result.name else { return nil }
                guard let location = result.location else { return nil }
                
                return Location.init(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            self.tableView.reloadData()
        }
    }
}
