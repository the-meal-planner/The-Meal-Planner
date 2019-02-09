//
//  FeedItemView.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/4/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit

class FeedItemView: UITableViewCell {
    
    var title: String = "undefined";
    
    
    @IBOutlet weak var NotificationView: UIView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var Timestamp: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        setup();
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        self.NotificationView.layer.cornerRadius = 3.0;
        self.NotificationView.layer.shadowOffset = CGSize(width: 2, height: 2);
        self.NotificationView.layer.shadowColor = UIColor.lightGray.cgColor;
        self.NotificationView.layer.shadowRadius = 2.0;
        self.NotificationView.layer.shadowOpacity = 1;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    
    private func setup() {
        
        
    }

}
