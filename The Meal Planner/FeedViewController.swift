//
//  FeedViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 1/30/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FeedViewController: UITableViewController {
    
    var feed: [NSDictionary] = [];
    var mainActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray);
    var viewProfileImage: UIImage = UIImage(named: "view_profile.png")!;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.mainActivityIndicator.center = self.view.center;
        self.mainActivityIndicator.hidesWhenStopped = true;
        self.view.addSubview(self.mainActivityIndicator);
        
        navigationController?.navigationBar.shadowImage = nil;
        
        let profile = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25));
        profile.translatesAutoresizingMaskIntoConstraints = false;
        profile.clipsToBounds = true;
        
        let refreshControl = UIRefreshControl();
        self.refreshControl = refreshControl;
        
        refreshControl.addTarget(self, action: #selector(FeedViewController.fetchFeedData), for: .valueChanged);
        
        profile.image = self.viewProfileImage;
        
        //Gesture recognizer
        let viewProfileTap = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.viewProfile(_:)));
        
        profile.isUserInteractionEnabled = true;
        profile.addGestureRecognizer(viewProfileTap);
        
        
        let viewProfileButton = UIBarButtonItem(customView: profile);
        
        viewProfileButton.target = self;
        viewProfileButton.action = #selector(FeedViewController.viewProfile(_:));
        
        
        
        self.navigationItem.rightBarButtonItem = viewProfileButton;
        
        
        
        fetchFeedData();
        
        
        
        
        //The current UID
        let uid = Auth.auth().currentUser?.uid;
        
        //Download from the storage bucket
        Storage.storage().reference(withPath: "/user/" + uid! + "/profile.png").getData(maxSize: 1 * 1024 * 1024){ (data, error) in
            
            if let error = error {
                //An error occurred
            } else {
                print("Data received");
                
                profile.image = UIImage(data: data!);
                
                viewProfileButton.customView = profile;
            }
            
        }
    }
    
    @objc func fetchFeedData() {
        
        //Start activityIndicator
        self.mainActivityIndicator.startAnimating();
        
        
        let uid = Auth.auth().currentUser!.uid;
        
        //TODO: Update this request with the correct paths and add Image support
        Database.database().reference(withPath: "/users/" + uid + "/notifications").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            //Reset data
            self.feed = [[:]];
            
            //Parse the data
            let feedItems = snapshot.value as? [ String : AnyObject ] ?? [:];
            
            
            for item in feedItems {
                let data = [
                    "timestamp": item.value["timestamp"],
                    "title": item.value["title"],
                    "content": item.value["content"]
                ];
                
                self.feed.append(data as NSDictionary);
                
            }
            
            if self.feed.count == 1 {
                self.feed.append([:]);
            }
            
            
            self.mainActivityIndicator.stopAnimating();
            self.tableView.reloadData();
            self.refreshControl!.endRefreshing();
        });
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.count;
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //tableView.rowHeight = UITableView.automaticDimension;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > 0 {
            
            if self.feed.count == 2 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoFeed", for: indexPath);
                
                return cell;
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItem", for: indexPath) as! FeedItemView;
                
                cell.Title?.text = self.feed[indexPath.row]["title"] as? String;
                cell.Content?.text = self.feed[indexPath.row]["content"] as? String;
                // cell.Content?.sizeToFit();
                //cell.NotificationView?.sizeToFit();
                
                return cell;
                
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealPlanItem", for: indexPath) as! UpNextTableCell;
            
            return cell;
        }
    }
    
    
    
    @objc func viewProfile(_ sender: UITapGestureRecognizer!) {
        print("Button tapped");
        performSegue(withIdentifier: "ProfileSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let destination = segue.destination as? ProfileViewController;
            let uid = Auth.auth().currentUser?.uid;
            destination!.uid = uid!;
        }
        
    }
    
    //For resizing images
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    


}
