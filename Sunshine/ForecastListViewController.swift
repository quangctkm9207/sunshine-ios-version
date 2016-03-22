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

    let data = [
        "March 22 - Clear - 32/22",
        "March 23 - Rain - 28/20",
        "March 24 - Clear - 32/22",
        "March 25 - Rain - 28/20",
        "March 26 - Clear - 32/22",
        "March 27 - Rain - 28/20",
        "March 28 - Clear - 32/22"
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
            print(parsedResult)
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

