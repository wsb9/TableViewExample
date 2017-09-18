//
//  NumberCell.swift
//  TableViewExample
//
//  Created by Cemen Istomin on 18.09.17.
//  Copyright © 2017 I Love View Inc. All rights reserved.
//

import UIKit

class NumberCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numberLabel.minimumScaleFactor = 0.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
