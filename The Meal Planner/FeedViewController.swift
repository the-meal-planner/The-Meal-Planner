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

class FeedViewController: UITableViewController {
    
    var feed: [NSDictionary] = [];
    var mainActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray);
    var viewProfileImage: UIImage = UIImage(named: "icons8-male-user-filled-24.png")!;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.mainActivityIndicator.center = self.view.center;
        self.mainActivityIndicator.hidesWhenStopped = true;
        self.view.addSubview(self.mainActivityIndicator);
        
        //Resize image
        let image = self.resizeImage(image: self.viewProfileImage, targetSize: CGSize(width: 30.0, height: 30.0));
        
        //View profile button
        let viewProfileButton = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(FeedViewController.viewProfile));
        
        self.navigationItem.rightBarButtonItem = viewProfileButton;
        
        fetchFeedData();
    }
    
    func fetchFeedData() {
        
        //Start activityIndicator
        self.mainActivityIndicator.startAnimating();
        
        
        let uid = Auth.auth().currentUser!.uid;
        
        //TODO: Update this request with the correct paths and add Image support
        Database.database().reference(withPath: "/users/" + uid + "/notifications").observe(DataEventType.value, with: { (snapshot) in
            
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
            
            self.mainActivityIndicator.stopAnimating();
            self.tableView.reloadData();
            
        });
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.count;
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.rowHeight = UITableView.automaticDimension;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItem", for: indexPath) as! FeedItemView;
            
            cell.Title?.text = self.feed[indexPath.row]["title"] as? String;
            cell.Content?.text = self.feed[indexPath.row]["content"] as? String;
           // cell.Content?.sizeToFit();
            //cell.NotificationView?.sizeToFit();
            
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealPlanItem", for: indexPath) as! UpNextTableCell;
            
            return cell;
        }
    }
    
    
    @objc func viewProfile() {
        print("Button Tapped");
    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
