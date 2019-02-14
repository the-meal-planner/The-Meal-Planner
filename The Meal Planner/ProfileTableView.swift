//
//  ProfileTableView.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/9/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit

class ProfileTableView: UITableView {

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

}
