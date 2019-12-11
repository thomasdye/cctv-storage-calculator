//
//  WebsiteViewController.swift
//  CCTV Storage Calculator
//
//  Created by Casualty on 10/11/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit
import WebKit
import UIKit
import WebKit
class WebsiteViewController: UIViewController,UIWebViewDelegate{
    
    //MARK: Declare IBOutlets
    @IBOutlet var webView : WKWebView!
    
    var myActivityIndicator = UIActivityIndicatorView()
    
    
    //Mark: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
//        searchButton.layer.cornerRadius = 12
//        searchButton.clipsToBounds = true
//        
//        btnBack.layer.cornerRadius = 15
//        btnNext.clipsToBounds = true
//        
//        btnNext.layer.cornerRadius = 15
//        btnNext.clipsToBounds = true
        
        //MARK: - Create Custom ActivityIndicator

        
        //Adding observer for show loading indicator

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                let url = URL(string: "https://optiviewusa.com/")!
        webView.load(URLRequest(url: url))
        
        myActivityIndicator.center = self.view.center
        myActivityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(myActivityIndicator)
        
        
                self.webView.addObserver(self, forKeyPath:#keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    
    //Mark: Search Using google query url
//    @IBAction func btnSearchAction(_ sender: UIButton) {
//        func searchTextOnGoogle(text: String){
//            let textComponent = text.components(separatedBy: " ")
//            let searchString = textComponent.joined(separator: "+")
//            let url = URL(string: "https://optiviewusa.com/?post_type=product&s=" + searchString)
//            let urlRequest = URLRequest(url: url!)
//            webView.load(urlRequest)
//        }
//        if let urlString = searchTextField.text{
//            if urlString.starts(with: "http://") || urlString.starts(with: "https://"){
//                webView.loadUrl(string: urlString)
//            }else if urlString.contains("www"){
//                webView.loadUrl(string: "http://\(urlString)")
//            }else{
//                searchTextOnGoogle(text: urlString)
//            }
//        }
//    }
    
    
    //Mark: Go previous page of Webview
//    @IBAction func btnBackAction(_ sender: UIButton) {
//        webView.goBack()
//    }
    
    //Mark: Go next page of Webview
//    @IBAction func btnNextAction(_ sender: Any) {
//        webView.goForward()
//    }
    
    
    //MARK: - ActivityIndicator StartAnimate And StopAnimate
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading"{
            if webView.isLoading{
                myActivityIndicator.startAnimating()
                myActivityIndicator.isHidden = false
            }else{
                myActivityIndicator.stopAnimating()
            }
        }
    }
}
//MARK: - Load Url In Webview
extension WKWebView {
    func loadUrl(string: String) {
        if let url = URL(string: string) {
            load(URLRequest(url: url))
        }
    }
}

