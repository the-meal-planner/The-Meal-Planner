//
//  ForgotPasswordViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 1/30/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        EmailAddress.delegate = self;
    }
    
    
    @IBOutlet weak var EmailAddress: UITextField!
    
    @IBAction func SendEmail(_ sender: Any) {
        let email = EmailAddress.text as! String;
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            if error == nil {
                self.dismiss(animated: true);
            }
            });
    }
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        
        return false;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
