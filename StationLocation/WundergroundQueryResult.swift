//
//  WundergroundQueryResult.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/16/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import Foundation

struct WundergroundQueryResult : Decodable // Encoding not needed now.
{
    let location: Location?
    let observation: WeatherObservation?
    
    private enum CodingKeys: String , CodingKey {
        case observation = "current_observation"
        case location
    }
    
    // convenience method for access to all WeatherStation(s) for query
    var stations : [WeatherStation]? {
        get{
            var stations : [WeatherStation]?
            if let airportStations = location?.nearbyStations?["airport"]?["station"]{
                // some station data is empty so filter it out
                let validStations = airportStations.filter({ (station) -> Bool in
                    return (station.city != "" && station.state != "")
                })
                stations = validStations
            }
            if let pwsStations = location?.nearbyStations?["pws"]?["station"]{
                stations?.append(contentsOf: pwsStations)
            }
            return stations
        }
    }
    
    init?(withJSONData data:Data) {
        do{
            let decoder = JSONDecoder()
            self = try decoder.decode(WundergroundQueryResult.self, from: data)
        } catch {
            return nil
        }        
    }
}

struct Location : Decodable
{
    var city: String?
    var country: String?
    var latitude: String?
    var longitude: String?

    /*
     Instead of a custom decoding setup, rely on automatic decoding and custom
     getters to parse data needed for the interface.  See WundergroundQueryResult.stations
     */
    fileprivate var nearbyStations: [String: [String: [WeatherStation] ] ]?

    private enum CodingKeys : String , CodingKey
    {
        case city
        case country
        case latitude = "lat"
        case longitude = "lon"
        case nearbyStations = "nearby_weather_stations"
    }
}

struct WeatherObservation : Decodable
{
    let temperature: String?
    let temperatureF: Double?
    let temperatureC: Double?
    
    private enum CodingKeys: String , CodingKey {
        case temperature = "temperature_string"
        case temperatureF = "temp_f"
        case temperatureC = "temp_c"
    }
    
}
