//
//  AddLocationViewModel.swift
//  Sky
//
//  Created by kuroky on 2019/1/7.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import Foundation
import CoreLocation

class AddLocationViewModel {
    var queryText: String = "" {
        didSet {
            geocode(address: queryText)
        }
    }
    
    private lazy var geocoder = CLGeocoder()
    private var isQuerying = false {
        didSet {
            queryingStatusDidChange?(isQuerying)
        }
    }
    
    private var locations: [Location] = [] {
        didSet {
            locationsDidChange?(locations)
        }
    }
    
    var queryingStatusDidChange: ((Bool) -> Void)?
    var locationsDidChange: (([Location]) -> Void)?
    
    var numberOfLocations: Int {
        return locations.count
    }
    
    var hasLocationsResult: Bool {
        return numberOfLocations > 0
    }
    
    func locationViewModel(at index: Int) -> LocationRepresentable? {
        guard let location = location(at: index) else {
            return nil
        }
        
        return LocationsViewModel(location: location.location, locationText: location.name)
    }
    
    func location(at index: Int) -> Location? {
        guard index < numberOfLocations else {
            return nil
        }
        
        return locations[index]
    }
    
    private func geocode(address: String?) {
        guard let address = address else {
            locations = []
            return
        }
        
        isQuerying = true
        
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            self?.processResponse(with: placemarks, error: error)
        }
    }
    
    private func processResponse(with placemarks: [CLPlacemark]?, error: Error?) {
        isQuerying = false
        var locs: [Location] = []
        
        if let error = error {
            print("Cannot handle Geocode Address! \(error)")
        }
        else if let results = placemarks {
            locs = results.compactMap {
                guard let name = $0.name else { return nil }
                guard let location = $0.location else { return nil }
                
                return Location.init(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            self.locations = locs
        }
    }
}
