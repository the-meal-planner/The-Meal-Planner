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
    @IBOutlet weak var MealName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MainView.layer.cornerRadius = 5.0;
        
        
        MainView.layer.shadowOffset = CGSize(width: 2, height: 2);
        MainView.layer.shadowColor = UIColor.lightGray.cgColor;
        MainView.layer.shadowRadius = 2.0;
        MainView.layer.shadowOpacity = 1;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
