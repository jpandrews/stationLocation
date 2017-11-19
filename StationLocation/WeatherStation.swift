//
//  WeatherStation.swift
//  StationLocation
//
//  Created by Justin Andrews on 11/14/17.
//  Copyright © 2017 Justin Andrews. All rights reserved.
//

import Foundation
import MapKit

class WeatherStation: NSObject , Decodable {
    
    /*
        Some properties are optional because the data is dependent on station type (airport/pws) but
     there is enough overlap I'm using the same class for both.
     */
    
    // Common properties
    
    // Prevent access to raw string data, prefer .coordinate
    // implemented in extension for MKAnnotation protocol
    private var longitude: String? = nil
    private var latitude: String? = nil
    
    var city: String = ""
    var state: String = ""
    var country: String = ""
    
    // Airport properties
    var icao: String? = nil
    // PWS properties
    var neighborhood: String? = nil
    var id: String? = nil
    var distanceKilometers: Double? = nil
    var distanceMiles: Double? = nil
    
    private enum CodingKeys : String , CodingKey {
        case longitude = "lon"
        case latitude = "lat"
        case city
        case state
        case country
        case icao
        case neighborhood
        case id
        case distanceKilometers = "distance_km"
        case distanceMiles = "distance_mi"
    }
    
    /*
     the actual JSON response is a bit different from the example response
     provided on the website. Values for keys 'lon' and 'lat' are Double and String
     so the decoder requires a custom setup to handle these cases
     */
    required init(from decoder: Decoder) throws
    {
        super.init()
        
        // root values
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
//        // hoping something like this would work, it did not...
//        for key in values.allKeys {
//            let value = try values.decode(String.self, forKey: key )
//            setValue(value, forKey: String(describing: key) )
//        }
        
        city    = try values.decode(String.self, forKey: .city )
        state   = try values.decode(String.self, forKey: .state )
        country = try values.decode(String.self, forKey: .country )
        
        icao    = try values.decodeIfPresent(String.self, forKey: .icao )
        id      = try values.decodeIfPresent(String.self, forKey: .id )
        neighborhood        = try values.decodeIfPresent(String.self, forKey: .neighborhood )
        distanceKilometers  = try values.decodeIfPresent(Double.self, forKey: .distanceKilometers )
        distanceMiles       = try values.decodeIfPresent(Double.self, forKey: .distanceMiles )
        
        do{
            latitude = String( try values.decode(Double.self, forKey: .latitude ) )
        } catch {
            latitude = try values.decode(String.self, forKey: .latitude )
        }
        
        do{
            longitude = String( try values.decode(Double.self, forKey: .longitude ) )
        }catch{
            longitude = try values.decode(String.self, forKey: .longitude )
        }

    }
}

extension WeatherStation: MKAnnotation
{
    var coordinate: CLLocationCoordinate2D {
        get{
            var coord = kCLLocationCoordinate2DInvalid
            if let lat = latitude , let lon = longitude {
                coord = CLLocationCoordinate2D.init(latitude: Double(lat) ?? 0 ,
                                                    longitude: Double(lon) ?? 0 )
            }
            return coord
        }
    }
}

