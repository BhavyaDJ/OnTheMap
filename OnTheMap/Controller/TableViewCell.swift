//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by Bhavya D J on 15/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabelText: UILabel!
    @IBOutlet weak var urlLabelText: UILabel!
    @IBOutlet weak var pinImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
