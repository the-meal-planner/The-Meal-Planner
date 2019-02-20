//
//  ProfileViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/15/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableHeader: ProfileTableHeader!
    @IBOutlet weak var tableView: UITableView!
    
    var uid: String = "";
    var image: UIImage = UIImage(named: "profile.png")!;
    
    //Keep track of the elements in our tableView
    var activity: [NSDictionary] = [];
    
    //Dynamic header height
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        let correctSize = tableHeader.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize);
        
        if tableHeader.frame.size.height != correctSize.height {
            tableHeader.frame.size.height = correctSize.height;
            
            tableView.layoutIfNeeded();
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set datasource and delegate of tableview
        tableView.delegate = self;
        tableView.dataSource = self;
        
        //Set estimated row height
        tableView.estimatedRowHeight = 123;
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //Set up refresh control
        let refreshControl = UIRefreshControl();
        
        refreshControl.addTarget(self, action: #selector(ProfileViewController.loadActivity), for: .valueChanged);
        
        tableView.refreshControl = refreshControl;
        
        loadActivity();
    }
    
    
    
    @objc func loadActivity() {
        
        //Get the current UID
        let uid = Auth.auth().currentUser?.uid;
        
        //Get the email
        Database.database().reference(withPath: "/users/" + uid! + "/email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as! String;
            
            print(value);
            self.tableHeader.Email!.text = value;
        });
        
        //Get the name
        Database.database().reference(withPath: "/users/" + uid! + "/name").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! [String : String];
            
            let firstname = value["first"];
            let lastname = value["last"];
            
            let fullname = firstname! + " " + lastname!;
            
            self.navigationItem.title = fullname;
        });
        
        //Get Image
        Storage.storage().reference(withPath: "/user/" + uid! + "/profile.png").getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                
            } else {
                let data = data!;
                
                let image = UIImage(data: data)!;
                
                self.image = image;
                

                self.tableHeader.ProfileImage?.image = image;
            }
        }
        
        //Query the database for the first ten pieces of activity sorted by timestamp
        Database.database().reference(withPath: "/users/" + uid! + "/activity").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //Get snapshot value
            let values = snapshot.value as? [String : AnyObject] ?? [:];
            
            
            //Store values
            var tempActivity: [NSDictionary] = [];
            
            //Loop through the data
            for value in values {
                
                let data = [
                    "title": value.value["title"],
                    "content": value.value["content"],
                    "timestamp": value.value["timestamp"]
                ];
                
                tempActivity.append(data as NSDictionary);
                
            }
            
            //Update activity array
            self.activity = tempActivity;
            
            //Stop refreshing
            self.tableView.refreshControl!.endRefreshing();
            
            //Reload tableView
            self.tableView.reloadData();
            
        });
 
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItem") as! FeedItemView;
        
        cell.Title?.text = activity[indexPath.row]["title"] as? String;
        cell.Content?.text = activity[indexPath.row]["content"] as? String;
        cell.ProfileImage?.image = self.image;
        cell.Timestamp?.text = activity[indexPath.row]["timestamp"] as? String;
        
        return cell;
    }
    
    
    //For smoother pull to refresh
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 123.0
    }
 
}
