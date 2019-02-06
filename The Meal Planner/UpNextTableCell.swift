//
//  UpNextTableCellTableViewCell.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/5/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit

class UpNextTableCell: UITableViewCell {

    @IBOutlet weak var MainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MainView.layer.cornerRadius = 5.0;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
