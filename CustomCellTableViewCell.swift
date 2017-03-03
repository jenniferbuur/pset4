//
//  CustomCellTableViewCell.swift
//  jenniferbuur_pset4
//
//  Created by Jennifer Buur on 01-03-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    @IBOutlet var todos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
