//
//  Constants.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import Foundation
struct Constants {
    
    
    //MARK: Setup APIs
    struct OpenWeatherMap {
        
        //MARK: API KEY
        static let ApiKey = "YourKey"
        
        //MARK: URLs
        static let ApiScheme = "http"
        static let ApiHost = "api.openweathermap.org"
        static let ApiPath = "/data/2.5/forecast/daily"
        
    }
    
    //MARK: Parameterkey
    struct OpenWeatherMapParameterKeys{
        static let Query = "q"
        static let Format = "mode"
        static let Units = "units"
        static let Days = "cnt"
        static let ApiKey = "APPID"
        
    }
    //MARK: ParameterValue
    struct OpenWeatherMapParameterValues{
        static let Format = "json"
        static let Units = "metric"
        static let Days = "14"
    }
    
    //MARK: ResponseKeys
    struct OpenWeatherMapReponseKeys{
        static let List = "list"
        static let DateTime = "dt"
        static let Temperature = "temp"
        static let TempMax = "max"
        static let TempMin = "min"
        static let Weather = "weather"
        static let WeatherID = "id"
        static let ShortDes = "main"
        static let Humidity = "humidity"
        static let Pressure = "pressure"
        static let WindSpeed = "speed"
    }
    
}
