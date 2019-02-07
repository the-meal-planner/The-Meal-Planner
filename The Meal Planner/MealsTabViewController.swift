//
//  MealsTabViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 2/6/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit
import FirebaseAuth

class MealsTabViewController: UIViewController {

    @IBAction func SignOut(_ sender: Any) {
        do {
            try Auth.auth().signOut();
        } catch {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
