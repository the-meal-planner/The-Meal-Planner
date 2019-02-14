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
    
    
    @IBOutlet weak var tableView: ProfileTableView!
    
    @IBOutlet weak var tableHeader: ProfileTableHeader!

    var originalHeaderPos = CGFloat(0);
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.prefetchDataSource = self as? UITableViewDataSourcePrefetching;
        
        tableView.layoutIfNeeded();
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //Add the pull to refresh controller
        let pullToRefresh = UIRefreshControl();
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullToRefresh;
        } else {
            tableView.addSubview(pullToRefresh);
        }
        
        //Add refresh target
        pullToRefresh.addTarget(self, action: #selector(ProfileViewController.fetchUserData), for: .valueChanged);
        
        fetchUserData();
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    
    @objc func fetchUserData() {
        
        //Reset activity
        self.activity = [];
        
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
            
            self.tableHeader.Email.text = value;
        });
        
        //Get the image
        Storage.storage().reference(withPath: "/user/" + self.uid + "/profile.png").getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                
            } else {
                let image = UIImage(data: data!)!;
                self.image = image;
                self.tableHeader.ProfileImage.image = image;
                
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
            
            self.tableView.layoutIfNeeded();
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
