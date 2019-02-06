//
//  SignInViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 1/29/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        EmailInput.delegate = self;
        PasswordInput.delegate = self;
    }
    

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    
    @IBAction func ForgotPassword(_ sender: Any) {
        let forgotPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController;
        
        self.present(forgotPasswordViewController, animated: true);
    }
    
    
    @IBAction func SignInPressed(_ sender: Any) {
        
        let email = EmailInput.text as! String;
        let password = PasswordInput.text as! String;
        
        let activityIndicator = UIActivityIndicatorView(style: .gray);
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        
        self.view.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            //Handle errors if necessary
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                        case .invalidEmail:
                            self.ErrorMessage.text = "Please Enter a Valid Email";
                        case .missingEmail:
                            self.ErrorMessage.text = "Please Enter your Account Email";
                        case .networkError:
                            self.ErrorMessage.text = "A Network Error has Occurred";
                        case .weakPassword:
                            self.ErrorMessage.text = "Password must be 6 or more characters";
                        case .wrongPassword:
                            self.ErrorMessage.text = "Invalid Username or Password";
                        case .userDisabled:
                            self.ErrorMessage.text = "This Account has been Disabled";
                        default:
                            self.ErrorMessage.text = "An error occurred";
                    }
                }
            }
            
            DispatchQueue.main.async {
                activityIndicator.stopAnimating();
            }
        };
    }
    
    
    @IBAction func CreateAccountPressed(_ sender: Any) {
        let createAccountViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController;
        
        self.present(createAccountViewController, animated: true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
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
