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
    
    let ShowForecastDetailSegue = "ShowForecastDetail"

    var foreCastArray = [ForecastDetail]()
    
    var choosenForecast: ForecastDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetch the data
        getForecastData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Check segue identifier
        if segue.identifier == self.ShowForecastDetailSegue {
            if let controller = segue.destinationViewController as? ForecastDetailViewController {
                controller.forecastDetail = choosenForecast
            }
        
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foreCastArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Get reusable cell by identifier
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        
        //Get the data for exact cell
        let forecast = foreCastArray[indexPath.row]
        
        //Populate the data to the cell
        cell.weatherIconImageView.image = Utils.getIconResourceForWeatherCondition(forecast.weatherCode)
        cell.dateLabelView.text = forecast.dateStr
        cell.shortDesLabelView.text = forecast.shortDes
        cell.maxTempLabel.text = "\(forecast.maxTemp) \u{00B0}"
        cell.minTempLabel.text = "\(forecast.minTemp) \u{00B0}"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Set the data to the choosen forecast detail which is used to send to the Detail View Controller
        choosenForecast = foreCastArray[indexPath.row]
        performSegueWithIdentifier(self.ShowForecastDetailSegue, sender: nil)
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
                guard let humidity = dailyForecast[Constants.OpenWeatherMapReponseKeys.Humidity] as? Float else {
                    
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
                let dateStr = self.formatDateToHumanReadableForm(dateTime)
                
                
                // Use the result
                let forecast = ForecastDetail(dateStr: dateStr, weatherCode: weatherId, shortDes: shortDes, maxTemp: Int(tempMax), minTemp: Int(tempMin), humidity: humidity, pressure: pressure, windSpeed:  windSpeed )
                
                self.foreCastArray.append(forecast)
            }
            
            //Reload data
            self.reloadData()
            
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

