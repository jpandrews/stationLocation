//
//  StationTableViewController.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/14/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import UIKit

class StationTableViewController: UITableViewController {

    var weatherStations: [WeatherStation]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Num stations \(String(describing: weatherStations?.count))")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            var title = station.city
            if let neighborhood = station.neighborhood{
                title = neighborhood + " in " + station.city
            }
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = station.state
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
