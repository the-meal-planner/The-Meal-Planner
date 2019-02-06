//
//  WebViewController.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 1/31/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var url = URL(string: "https://google.com");
    var webView: WKWebView!;
    var loader: UIActivityIndicatorView!;
    
    
    
    override func loadView() {
        webView = WKWebView();
        webView.navigationDelegate = self;
        webView.uiDelegate = self;
        view = webView;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped));
        
        done.tintColor = UIColor.white;
        
        navigationItem.rightBarButtonItem = done;
        
        loader = UIActivityIndicatorView(style: .gray);
        loader.hidesWhenStopped = true;
        loader.center = view.center;
        view.addSubview(loader);
        
        loader.startAnimating();
        
        
        let request = URLRequest(url: url!);
        webView.load(request);
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @objc func doneTapped() {
        self.dismiss(animated: true);
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title;
    }

}
