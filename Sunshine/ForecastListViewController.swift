//
//  ViewController.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import UIKit
import Foundation

class ForecastListViewController: UITableViewController {

    var data: [String] = [
        "1","2"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetch the data
        getForecastData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Get reusable cell by identifier
        let cell = tableView.dequeueReusableCellWithIdentifier("ForecastCell")!
        
        //Get the data for exact cell
        let forecastStr = data[indexPath.row]
        
        //Populate the data to the cell
        cell.textLabel?.text = forecastStr
        
        return cell
    }
    
    //Send HTTP request to server and get the data
    private func getForecastData(){
        
        //MARK: Get the query parameters
        let methodParameters = [
            Constants.OpenWeatherMapParameterKeys.ApiKey : Constants.OpenWeatherMap.ApiKey,
            Constants.OpenWeatherMapParameterKeys.Query : "94030",
            Constants.OpenWeatherMapParameterKeys.Format : Constants.OpenWeatherMapParameterValues.Format,
            Constants.OpenWeatherMapParameterKeys.Days : Constants.OpenWeatherMapParameterValues.Days,
            Constants.OpenWeatherMapParameterKeys.Units : Constants.OpenWeatherMapParameterValues.Units
        ]
        
        //MARK: Build the URLs
        let url = openWeatherMapURLFromParameters(methodParameters)
        
        //MARK: Create the request
        let request = NSURLRequest(URL: url)
        
        //MARK: Make the request 
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) in
            
            func displayError(error: String){
                print(error)
                //TODO: let user know more about the error
            }
            
            //GUARD: was there any error? 
            guard error == nil else {
                displayError("There was an error when making request \(error)")
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
                guard let dateTime = dailyForecast[Constants.OpenWeatherMapReponseKeys.DateTime] as? Double else {
                    
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.DateTime) in \(dailyForecast)")
                    return
                }
                
                guard let tempDictionary = dailyForecast[Constants.OpenWeatherMapReponseKeys.Temperature] as? [String: AnyObject] else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.Temperature) in \(dailyForecast)")
                    return
                }
                
                guard let tempMax = tempDictionary[Constants.OpenWeatherMapReponseKeys.TempMax] as? Float else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.TempMax) in \(tempDictionary)")
                    return
                }
                
                guard let tempMin = tempDictionary[Constants.OpenWeatherMapReponseKeys.TempMin] as? Float else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.TempMin) in \(tempDictionary)")
                    return
                }
                
                guard let weatherArray = dailyForecast[Constants.OpenWeatherMapReponseKeys.Weather] as? [[String: AnyObject]] else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.Weather) in \(dailyForecast)")
                    return
                }
                
                let weatherDictionary = weatherArray[0] as [String: AnyObject]
                
                guard let shortDes = weatherDictionary[Constants.OpenWeatherMapReponseKeys.ShortDes] as? String else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.ShortDes) in \(weatherDictionary)")
                    return
                }
                guard let weatherId = weatherDictionary[Constants.OpenWeatherMapReponseKeys.WeatherID] as? Int else {
                    displayError("Cannot find the key \(Constants.OpenWeatherMapReponseKeys.WeatherID) in \(weatherDictionary)")
                    return
                }
                
                //convert the date 
                let dateStr = self.formatDateToHumanReadableForm(dateTime)
                
                // Use the result
                let forecastStr = "\(dateStr)-\(shortDes)-\(tempMax)/\(tempMin)"
                self.data.append(forecastStr)
            }
            
            //Reload data
            self.reloadData()
            
        }
        
        // Start the request
        self.data.removeAll()
        
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
    
    //Reload data of the table view
    private func reloadData() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    //Format date
    private func formatDateToHumanReadableForm(dateDouble: Double) -> String{
        let timeInterval: NSTimeInterval = dateDouble
        let date = NSDate(timeIntervalSince1970 : timeInterval)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "LLL dd"
        
        return dateFormatter.stringFromDate(date)
        
    }

}

