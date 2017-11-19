//
//  WundergroundQuery.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/17/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import Foundation

struct WundergroundQuery
{
    static private let API_KEY: String = ""
    
    enum Features : String {
        case Geolookup = "geolookup"
        case CurrentConditions = "conditions"
        case Autocomplete = "autocomplete"
    }
    
    enum OutputFormat : String {
        case XML = "xml"
        case JSON = "json"
    }
    
    // by default we want both features,
    // this provides a mechanism for modifying them though
    var features: [Features] = [.Geolookup,.CurrentConditions]
    var outputFormat: OutputFormat = .JSON
    let query: String
    
    init?(withCity city:String , state:String )
    {
        if state.count != 2 || city.count == 0 {
            return nil
        }
        query = state + "/" + city.replacingOccurrences(of: " ", with: "_")
    }
    
    init(withLatitude lat: Double , longitude lon: Double) {
        query = String(lat) + "," + String(lon)
    }
    
    // http://api.wunderground.com/api/__Your_Key__/features/(settings)/q/query.format
    var URL: URL?
    {
        get{
            var urlComponents = URLComponents.init()
            urlComponents.scheme = "https"
            urlComponents.host   = "api.wunderground.com"
            
            let apiPath         = "/api/" + WundergroundQuery.API_KEY
            let featurePath     = features.map({ $0.rawValue }).joined(separator: "/")
            let queryPath       = "q/" + query
            let fileExtension   = "." + outputFormat.rawValue
            
            urlComponents.path  = [apiPath , featurePath , queryPath].joined(separator: "/") + fileExtension
            
            return urlComponents.url
        }
    }
    
}
