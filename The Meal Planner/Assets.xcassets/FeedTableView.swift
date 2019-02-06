//
//  FeedTableView.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/5/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit

class FeedTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style);
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup() {
        
    }
}
