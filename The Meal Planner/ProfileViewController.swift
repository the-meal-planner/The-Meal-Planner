//
//  ProfileViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/7/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FeedItem", for: indexPath) as! FeedItemView;
        
        cell.Title?.text = self.activity[indexPath.row]["title"] as? String;
        cell.Content?.text = self.activity[indexPath.row]["content"] as? String;
        cell.Timestamp?.text = self.activity[indexPath.row]["content"] as? String;
        cell.ProfileImage?.image = self.image;
        
        return cell;
    }
    
    
    
    var uid = "";
    var image: UIImage = UIImage(named: "profile.png")!;
    var name = "";
    
    var activity: [NSDictionary] = [
        [
            "title": "Test",
            "content": "Test",
            "timestamp": 11
        ],
        [
            "title": "Test",
            "content": "Test",
            "timestamp": 11
        ],
        [
            "title": "Test",
            "content": "Test",
            "timestamp": 11
        ],
        [
            "title": "Test",
            "content": "Test",
            "timestamp": 11
        ]
    ];
    
    var headerHeight: CGFloat = CGFloat(0);
    
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var Email: UILabel!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Header: UIView!
    
    @IBOutlet weak var HeaderTopAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var containerScrollview: UIScrollView!
    
    @IBOutlet weak var ScrollviewBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.containerScrollview.delegate = self;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.prefetchDataSource = self as? UITableViewDataSourcePrefetching;
        
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
        
        self.tableView.contentInset = UIEdgeInsets(top: Header.frame.height, left: 0, bottom: 0, right: 0);
        
        self.tableHeight.constant = self.tableView.contentSize.height;
        
        headerHeight = Header.frame.height;
        
        tableView.layoutIfNeeded();
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        fetchUserData();
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y - tableView.contentOffset.y;
        
        HeaderTopAnchor.constant = y - headerHeight;
        
        if HeaderTopAnchor.constant > 0 || HeaderTopAnchor.constant == -headerHeight {
            HeaderTopAnchor.constant = 0;
        }
        
        //Dtect if we have scrolled to the bottom
    }
    
    
    func fetchUserData() {
        
        //Get the name
        Database.database().reference(withPath: "/users/" + self.uid + "/name").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String : AnyObject ] ?? [:];
            let firstName = value["first"] as! String;
            let lastName = value["last"] as! String;
            
            self.name = firstName + " " + lastName;
            self.navigationItem.title = self.name;
        });
        
        //Get the email
        Database.database().reference(withPath: "/users/" + self.uid + "/email").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? String ?? "";
            
            self.Email.text = value;
        });
        
        //Get the image
        Storage.storage().reference(withPath: "/user/" + self.uid + "/profile.png").getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                
            } else {
                let image = UIImage(data: data!)!;
                self.image = image;
                self.ProfileImage.image = image;
                
                self.tableView.reloadData();
            }
            
        }
        
        
        
        
        /******************
         Load the recent activity
         ******************/
        
        //Fetches the 10 most recent activities, sorted by timestamp
        Database.database().reference(withPath: "/users/" + self.uid + "/activity").queryOrdered(byChild: "timestamp").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { snapshot in
            
            //Get the value
            let value = snapshot.value as? [String : AnyObject];
            
            //Loop through each one
            for item in value! {
                let data: NSDictionary = [
                    "title": item.value["title"] as Any,
                    "content": item.value["content"] as Any,
                    "timestamp": item.value["timestamp"] as Any
                ];
                
                self.activity.append(data);
            }
            
            self.tableView.reloadData();
            
        });
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
