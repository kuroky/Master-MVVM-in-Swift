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
    
    var delegate: AddLocationViewControllerDelegate?
    var viewModel: AddLocationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add a location"
        self.setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    func setupData() {
        self.viewModel = AddLocationViewModel()
        self.viewModel.locationsDidChange = {
            [unowned self] locations in
            self.tableView.reloadData()
        }
        
        self.viewModel.queryingStatusDidChange = {
            [unowned self] isQuerying in
            if isQuerying {
                self.navigationItem.title = "Searching..."
            }
            else {
                self.navigationItem.title = "Add a location"
            }
        }
    }
}

extension AddLocationViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfLocations
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Unexpected table view cell")
        }
        
        if let location = self.viewModel.locationViewModel(at: indexPath.row) {
            cell.configItem(item: location)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let location = self.viewModel.location(at: indexPath.row) else { return }
        self.delegate?.controller(self, didAddLocation: location)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.viewModel.queryText = searchBar.text ?? ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.viewModel.queryText = searchBar.text ?? ""
    }
}
