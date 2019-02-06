//
//  CreateAccountViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 1/29/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage



class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FirstName.delegate = self;
        LastName.delegate = self;
        Email.delegate = self;
        Password.delegate = self;
        ConfirmPassword.delegate = self;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Error: UILabel!
    
    
    @IBAction func PasswordChanged(_ sender: Any) {
        if (Password.text == ConfirmPassword.text) {
            Image.image = UIImage(imageLiteralResourceName: "icons8-ok-filled-50.png");
        } else {
            Image.image = UIImage(imageLiteralResourceName: "icons8-cancel-filled-50.png");
        }
    }
    
    
    @IBAction func ConfirmPasswordChanged(_ sender: Any) {
        if (Password.text == ConfirmPassword.text) {
            Image.image = UIImage(imageLiteralResourceName: "icons8-ok-filled-50.png");
        } else {
            Image.image = UIImage(imageLiteralResourceName: "icons8-cancel-filled-50.png");
        }
    }
    
    
    @IBAction func CreateAccount(_ sender: Any) {
        let activityIndicator = UIActivityIndicatorView(style: .gray);
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        
        self.view.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        
        //Create the account
        let firstName = FirstName.text as! String;
        let lastName = LastName.text as! String;
        let email = Email.text as! String;
        let password = Password.text as! String;
        let confirmPassword = Password.text as! String;
        
        //Are we going to continue?
        var valid = true;
        
        //Check for valid first name
        if firstName.count == 0 {
            valid = false;
            self.Error.text = "First Name is a required field";
        }
        
        //Check for invalid last name
        if lastName.count == 0 {
            valid = false;
            self.Error.text = "Last Name is a required field";
        }
        
        //Check for invalid email
        if email.count == 0 {
            valid = false;
            self.Error.text = "Email is a required field";
        }
        
        //Check for invalid password
        if !(password == confirmPassword) {
            valid = false;
            self.Error.text = "Passwords do not match";
        }
        
        if valid {
            
            let data: NSDictionary = [
                "firstname": firstName,
                "lastname": lastName,
                "email": email,
                "data": [
                    "mealtimes":[],
                    "plan": [
                    [
                    "name": "Sunday",
                    "mealtimes": 1
                    ],
                    [
                    "name": "Monday",
                    "mealtimes": 1
                    ],
                    [
                    "name": "Tuesday",
                    "mealtimes": 1
                    ],
                    [
                    "name": "Wednesday",
                    "mealtimes": 1
                    ],
                    [
                    "name": "Thursday",
                    "mealtimes": 1
                    ],
                    [
                    "name": "Friday",
                    "mealtimes": 1
                    ],
                    [
                    "name": "Saturday",
                    "mealtimes": 1
                    ]
                    ],
                    "meals":[]
                ],
                "config": true,
                "ads": [
                    "placeholder": 1
                ]
            ];
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
                
                if error != nil {
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                            case .emailAlreadyInUse:
                                self.Error.text = "Sorry, that email has been used by another user";
                            case .weakPassword:
                                self.Error.text = "Password must be 6 characters or more";
                            case .invalidEmail:
                                self.Error.text = "Please enter a valid email";
                            case .networkError:
                                self.Error.text = "A network error has occurred";
                            default:
                                self.Error.text = "An error has occurred";
                        }
                    }
                    
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating();
                    }
                } else {
                    guard let user = authResult?.user else {return}
                
                    let uid = user.uid;
                
                    Database.database().reference(withPath: "/users/" + uid).setValue(data);
                
                    //Download default profile image
                    let img = Storage.storage().reference(withPath: "/system/empty-profile.png");
                    img.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if error != nil {
                            //An error occurred
                        } else {
                            let image = data!;
                            
                            Storage.storage().reference(withPath: "/user/" + uid + "/profile.png").putData(image, metadata: nil) { (metadata, error) in
                                
                                if let error = error {
                                    //Error occurred
                                } else {
                                    //No error occurred
                                    DispatchQueue.main.async {
                                        activityIndicator.stopAnimating();
                                    }
                                }
                            };
                        }
                    }
                }
            });
            
        }
    }
    
    
    @IBAction func PrivacyPolicy(_ sender: Any) {
        let url = URL(string: "https://themealplannerapp.com/privacy-policy/")!;
        
        let webViewController = WebViewController();
        webViewController.url = url;
        webViewController.title = "Privacy Policy - The Meal Planner";
        let navigation = UINavigationController(rootViewController: webViewController);
        navigation.navigationBar.barTintColor = UIColor(displayP3Red: 0, green: 102/255, blue: 255/255, alpha: 1);
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.7)
        ];
        
        navigation.navigationBar.titleTextAttributes = attrs;
        self.present(navigation, animated: true);
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
}
