//
//  FeedTableViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/15/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default");
        
        return cell!;
    }
    
    @IBOutlet weak var tableView: UITableView!
    var feedItems: [NSDictionary] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        let rc = UIRefreshControl();
        
        rc.addTarget(self, action: #selector(ViewController.load), for: .valueChanged);
        
        tableView.refreshControl = rc;
    }
    
    @objc func load() {
        let uid = Auth.auth().currentUser!.uid;
        
        //TODO: Update this request with the correct paths and add Image support
        Database.database().reference(withPath: "/users/" + uid + "/notifications").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            //Reset data
            self.feedItems = [[:]];
            
            //Parse the data
            let feed = snapshot.value as? [ String : AnyObject ] ?? [:];
            
            
            for item in feed {
                let data = [
                    "timestamp": item.value["timestamp"],
                    "title": item.value["title"],
                    "content": item.value["content"]
                ];
                
                self.feedItems.append(data as NSDictionary);
                
            }
            
            if self.feedItems.count == 1 {
                self.feedItems.append([:]);
            }
            
            
            
            self.tableView.reloadData();
            self.tableView.refreshControl!.endRefreshing();
        });
    }
    
    
}

