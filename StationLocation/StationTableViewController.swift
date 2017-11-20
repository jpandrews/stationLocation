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

    override func viewDidLoad() {
        // simple solution to let the user know zero stations were found
        // could also use a different cell type or swap the data source/delegate
        if weatherStations?.count == 0 {
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 30))
            label.text = "Zero weather stations within 40km"
            label.textAlignment = NSTextAlignment.center
            self.tableView.tableHeaderView = label
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
                distanceString = String(format: "%.01f" , distance) + " km"
            }
            cell.detailTextLabel?.text = distanceString
            
        }
        return cell
    }
}
