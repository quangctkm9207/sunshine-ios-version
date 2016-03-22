//
//  CustomTableViewCell.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var shortDesLabelView: UILabel!
    @IBOutlet weak var dateLabelView: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
