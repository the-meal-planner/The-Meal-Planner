//
//  ProfileTableHeader.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/9/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit

class ProfileTableHeader: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var Email: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("ProfileTableHeader", owner: self, options: nil);
        addSubview(mainView);
        mainView.frame = self.bounds;
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }

}
