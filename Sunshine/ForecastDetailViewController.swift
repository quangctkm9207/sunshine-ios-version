//
//  ForecastDetailViewController.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController {
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherArtImageView: UIImageView!

    
    var forecastDetail: ForecastDetail!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        //Show forecast detail 
        self.dateLabel.text = forecastDetail.dateStr
        self.maxLabel.text = "\(forecastDetail.maxTemp) \u{00B0}"
        self.minTempLabel.text = "\(forecastDetail.minTemp) \u{00B0}"
        self.desLabel.text = forecastDetail.shortDes
        self.humidityLabel.text = "Humidity: \(forecastDetail.humidity) %"
        self.pressureLabel.text = "Pressure: \(forecastDetail.pressure) hPa"
        self.windLabel.text = "Wind speed: \(forecastDetail.windSpeed) km/h"
        self.weatherArtImageView.image = Utils.getArtResourceForWeatherCondition(forecastDetail.weatherCode)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

