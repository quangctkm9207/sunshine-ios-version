//
//  ViewController.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import UIKit
import Foundation

class ForecastListViewController: UITableViewController, UITextFieldDelegate, OnLoadDataListener{
    let ShowForecastDetailSegue = "ShowForecastDetail"

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var notiLabel: UILabel!

    var foreCastArray = [ForecastDetail]()
    
    var choosenForecast: ForecastDetail!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    var notification: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        
        //Customize Navigation Bar
        customizeNavigationBar()
        
        //Enable UI View
        self.enableUIView(true)
        
        //Fetch the data
        
        let defaultLocation = "Kyoto"
        self.updateData(defaultLocation)
        self.searchTextField.text = defaultLocation
      
    }
    @IBAction func updateWeatherByLocation(sender: AnyObject) {
        self.foreCastArray.removeAll()
        self.tableView.reloadData()
        let location = searchTextField.text!
        self.updateData(location)
    }
    private func updateData(locationSearch: String){
        //Disable UI when loading data
        self.enableUIView(false)
        
        let client = OpenWeatherMapClient()
        client.onLoadFinishListener = self
        client.getForecastData(locationSearch)
    }
    
    private func customizeNavigationBar(){
        // Change the navigation bar background color to blue.
        navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        // Change the color of the navigation bar button items to white.
        navigationController!.navigationBar.tintColor = UIColor.blackColor()
        // Change the color of the navigation bar title text to yellow.
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.blackColor()]
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
    
    
    //Override the onFinish method from OnLoadFinishListener
    func OnFinish(forecastArray: [ForecastDetail], notification: String) {
        self.notification = notification
        self.enableUIView(true)
        self.foreCastArray = forecastArray
        self.reloadData()
    }
    
    
    
    //update data of the table view
    private func reloadData() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.enableUIView(true)
            self.tableView.reloadData()
        })
    }
    
    private func enableUIView(enabled: Bool){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.notiLabel.text = self.notification
            if !enabled {
                self.progressIndicator.startAnimating()
            }else {
                self.progressIndicator.stopAnimating()
            }
            self.searchTextField.enabled = enabled
            self.searchButton.enabled = enabled
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
}

