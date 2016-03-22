//
//  OpenWeatherMapClient.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import UIKit

class OpenWeatherMapClient: NSObject {
    
    var forecastArray = [ForecastDetail]()
    
    var onLoadFinishListener: OnLoadDataListener!
    
    //Send HTTP request to server and get the data
    func getForecastData(locationSearch: String) {
        
        //MARK: Get the query parameters
        let methodParameters = [
            Constants.OpenWeatherMapParameterKeys.ApiKey : Constants.OpenWeatherMap.ApiKey,
            Constants.OpenWeatherMapParameterKeys.Query : locationSearch,
            Constants.OpenWeatherMapParameterKeys.Format : Constants.OpenWeatherMapParameterValues.Format,
            Constants.OpenWeatherMapParameterKeys.Days : Constants.OpenWeatherMapParameterValues.Days,
            Constants.OpenWeatherMapParameterKeys.Units : Constants.OpenWeatherMapParameterValues.Units
        ]
        
        //MARK: Build the URLs
        let url = openWeatherMapURLFromParameters(methodParameters)
        
        //MARK: Create the request
        let request = NSMutableURLRequest(URL: url)
        request.timeoutInterval = 20
        //MARK: Make the request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) in
            
            func displayError(error: String){
                print(error)
                //TODO: let user know more about the error
                self.onLoadFinishListener.OnFinish(self.forecastArray)
            }
            
            //GUARD: was there any error?
            guard error == nil else {
                displayError("There was an error when making request \(error!)")
                return
            }
            
            //GUARD: was data is empty
            guard let data = data else{
                displayError("No data was returned")
                return
            }
            
            //Parse the data
            let parsedResult: AnyObject!
            do{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            }catch{
                displayError("Cannot parse the data \(data)")
                return
            }
            
            guard let foreCastArray = parsedResult[Constants.OpenWeatherMapReponseKeys.List] as? [[String:AnyObject]] else{
                displayError("Cannot find the key '\(Constants.OpenWeatherMapReponseKeys.List)'")
                return
            }
            
            // Go throught all forecast and parse the detail resutl
            for var i = 0; i < foreCastArray.count; i++ {
                let dailyForecast = foreCastArray[i] as [String:AnyObject]
                
                // Date in milliseconds
                guard let dateTime = dailyForecast[Constants.OpenWeatherMapReponseKeys.DateTime] as? Double else {
                    
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.DateTime) in \(dailyForecast)")
                    return
                }
                
                guard let tempDictionary = dailyForecast[Constants.OpenWeatherMapReponseKeys.Temperature] as? [String: AnyObject] else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.Temperature) in \(dailyForecast)")
                    return
                }
                
                
                //Maximum temperature
                guard let tempMax = tempDictionary[Constants.OpenWeatherMapReponseKeys.TempMax] as? Float else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.TempMax) in \(tempDictionary)")
                    return
                }
                
                //Minimum temperature
                guard let tempMin = tempDictionary[Constants.OpenWeatherMapReponseKeys.TempMin] as? Float else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.TempMin) in \(tempDictionary)")
                    return
                }
                
                guard let weatherArray = dailyForecast[Constants.OpenWeatherMapReponseKeys.Weather] as? [[String: AnyObject]] else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.Weather) in \(dailyForecast)")
                    return
                }
                
                
                let weatherDictionary = weatherArray[0] as [String: AnyObject]
                
                //Short weather description
                guard let shortDes = weatherDictionary[Constants.OpenWeatherMapReponseKeys.ShortDes] as? String else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.ShortDes) in \(weatherDictionary)")
                    return
                }
                
                //Weather ID code
                guard let weatherId = weatherDictionary[Constants.OpenWeatherMapReponseKeys.WeatherID] as? Int else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.WeatherID) in \(weatherDictionary)")
                    return
                }
                
                
                //Humidity
                guard let humidity = dailyForecast[Constants.OpenWeatherMapReponseKeys.Humidity] as? Int else {
                    
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.Humidity) in \(dailyForecast)")
                    return
                }
                
                //Pressure
                guard let pressure = dailyForecast[Constants.OpenWeatherMapReponseKeys.Pressure] as? Float else {
                    
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.Pressure) in \(dailyForecast)")
                    return
                }
                
                //Wind speed
                guard let windSpeed = dailyForecast[Constants.OpenWeatherMapReponseKeys.WindSpeed] as? Float else {
                    
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.WindSpeed) in \(dailyForecast)")
                    return
                }
                
                //convert the date
                let dateStr = Utils.formatDateToHumanReadableForm(dateTime)
                
                
                // Use the result
                let forecast = ForecastDetail(dateStr: dateStr, weatherCode: weatherId, shortDes: shortDes, maxTemp: Int(tempMax), minTemp: Int(tempMin), humidity: humidity, pressure: pressure, windSpeed:  windSpeed )
                
                self.forecastArray.append(forecast)
            }
            self.onLoadFinishListener.OnFinish(self.forecastArray)
        }
        
        // Start the request
        task.resume()
        
    }
    
    //Build URLs
    func openWeatherMapURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Constants.OpenWeatherMap.ApiScheme
        urlComponents.host = Constants.OpenWeatherMap.ApiHost
        urlComponents.path = Constants.OpenWeatherMap.ApiPath
        urlComponents.queryItems = [NSURLQueryItem]()
        
        for (key,value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems!.append(queryItem)
        }
        return urlComponents.URL!
    }


}

protocol OnLoadDataListener {
    func OnFinish(forecastArray: [ForecastDetail])
}
