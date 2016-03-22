//
//  ForecastDetail.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import Foundation
struct ForecastDetail{
    let dateStr: String
    let weatherCode: Int
    let shortDes: String
    let maxTemp: Float
    let minTemp: Float
    
    
    //MARK: Initializers
    init(dateStr: String, weatherCode: Int, shortDes: String, maxTemp: Float, minTemp: Float){
        self.dateStr = dateStr
        self.weatherCode = weatherCode
        self.shortDes = shortDes
        self.maxTemp = maxTemp
        self.minTemp = minTemp
    }
}