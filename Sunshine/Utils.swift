//
//  Utils.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import Foundation
import UIKit
class Utils {
    /**
     * Helper method to provide the icon according to the weather condition id returned
     * by the OpenWeatherMap call.
     *
     * @param weatherId from OpenWeatherMap API response
     * @return resource id for the corresponding icon. nil if no relation is found.
     */
    static func getIconResourceForWeatherCondition(weatherId: Int ) -> UIImage?{
        // Based on weather code data found at:
        // http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
        if (weatherId >= 200 && weatherId <= 232) {
            return UIImage(named: "ic_storm")!
        } else if (weatherId >= 300 && weatherId <= 321) {
            return UIImage(named: "ic_light_rain")!
        } else if (weatherId >= 500 && weatherId <= 504) {
            return UIImage(named: "ic_rain")!
        } else if (weatherId == 511) {
            return UIImage(named: "ic_snow")!
        } else if (weatherId >= 520 && weatherId <= 531) {
            return UIImage(named: "ic_rain")!
        } else if (weatherId >= 600 && weatherId <= 622) {
            return UIImage(named: "ic_snow")!
        } else if (weatherId >= 701 && weatherId <= 761) {
            return UIImage(named: "ic_fog")!
        } else if (weatherId == 761 || weatherId == 781) {
            return UIImage(named: "ic_storm")!
        } else if (weatherId == 800) {
            return UIImage(named: "ic_clear")!
        } else if (weatherId == 801) {
            return UIImage(named: "ic_light_clouds")!
        } else if (weatherId >= 802 && weatherId <= 804) {
            return UIImage(named: "ic_cloudy")!
        }
        return nil
    }
    
    
    //For color big art icon
    static func getArtResourceForWeatherCondition(weatherId: Int ) -> UIImage?{
   
        if (weatherId >= 200 && weatherId <= 232) {
            return UIImage(named: "art_storm")!
        } else if (weatherId >= 300 && weatherId <= 321) {
            return UIImage(named: "art_light_rain")!
        } else if (weatherId >= 500 && weatherId <= 504) {
            return UIImage(named: "art_rain")!
        } else if (weatherId == 511) {
            return UIImage(named: "art_snow")!
        } else if (weatherId >= 520 && weatherId <= 531) {
            return UIImage(named: "art_rain")!
        } else if (weatherId >= 600 && weatherId <= 622) {
            return UIImage(named: "art_snow")!
        } else if (weatherId >= 701 && weatherId <= 761) {
            return UIImage(named: "art_fog")!
        } else if (weatherId == 761 || weatherId == 781) {
            return UIImage(named: "art_storm")!
        } else if (weatherId == 800) {
            return UIImage(named: "art_clear")!
        } else if (weatherId == 801) {
            return UIImage(named: "art_light_clouds")!
        } else if (weatherId >= 802 && weatherId <= 804) {
            return UIImage(named: "art_clouds")!
        }
        return nil
    }
    
    //Format date
    static func formatDateToHumanReadableForm(dateDouble: Double) -> String{
        let timeInterval: NSTimeInterval = dateDouble
        let date = NSDate(timeIntervalSince1970 : timeInterval)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "LLL dd"
        
        return dateFormatter.stringFromDate(date)
        
    }

    
}