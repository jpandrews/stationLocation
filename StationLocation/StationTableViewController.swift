//
//  StationTableViewController.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/14/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import UIKit

class StationTableViewController: UITableViewController {

    // sort the weather stations after setting them
    var weatherStations: [WeatherStation]? {
        didSet{
            if let stations = weatherStations {
                weatherStations = stations.sorted(by: { (stationA, stationB) -> Bool in
                    let compareA = stationA.neighborhood ?? stationA.city
                    let compareB = stationB.neighborhood ?? stationB.city
                    return compareA.compare(compareB) == ComparisonResult.orderedAscending
                })
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherStations?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath)

        if let station = weatherStations?[indexPath.row]{
            // Configure the cell...
            let title = station.neighborhood ?? station.city
            cell.textLabel?.text = title + ", " + station.state
            
            //
            var distanceString = "Distance n/a"
            if let distance = station.distanceKilometers {
                distanceString = String(distance) + " km"
            }
            cell.detailTextLabel?.text = distanceString
            
        }
        return cell
    }
}
